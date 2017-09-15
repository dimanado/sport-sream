class Business < ActiveRecord::Base
  belongs_to :merchant

  has_many :campaigns, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :consumer
  has_many :shopping_cart_items, through: :campaigns
  has_and_belongs_to_many :categories
  has_one :partner, :through => :merchant

  # you can use Business.include(:logo_files) to prevent quering in loop for each business.logo call
  # :logo_files is an attachinary auto-created relation, but is hidden by default
  has_attachment :logo, accept: [:jpg, :png, :gif]
  has_attachments :images, maximum: 10

  attr_reader :distance

  attr_accessible :name, :city, :state, :address, :zip_code, :phone, :image, :website, :description, :category_ids, :latitude, :longitude, :online_business, :facebook_page_identifier

  scope :matching_category, lambda {|category|
    if category.parent.present?
      conditions = {:id => [category.id, category.parent.id]}
    elsif category.has_subcategories?
      conditions = {:id => [category.id] + category.child_ids}
    else
      conditions = {:id => [category.id]}
    end
    joins(:categories).
    where(:categories => conditions).uniq
  }

  validates :name, :zip_code, :phone, :presence => true
  with_options if: Proc.new{|business| business.online_business.nil? || business.online_business == '0'} do |business|
    business.validates :state, :city, :address, presence: true
    business.validates_format_of :zip_code, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234"
  end
  validates :website, :presence => true, if: Proc.new{|business| business.online_business == '1'}


  before_save :geocode, :if => :zip_code_changed?

  scope :with_name_like, lambda { |name| where('lower(businesses.name) LIKE ?', "%#{name.downcase}%") }

  # this scope attaches number of active campaigns to businesses
  # but makes one query other than of Business#count_active_campaigns
  # so the query is a plain variant of that query
  # using plain sql for complex join
  scope :with_campaign_counts, lambda {
    select("`businesses`.*, COUNT(`campaigns`.`id`) as `campaigns_count`")
    .joins("LEFT JOIN `campaigns`"\
           " ON `campaigns`.`business_id` = `businesses`.`id`"\
           " AND `campaigns`.`state` = 'delivered'"\
           " AND `campaigns`.`deleted_at` IS NULL"\
           " AND `campaigns`.`expires_at` > '#{Time.zone.now}'")
    .group("`businesses`.`id`")
  }

  paginates_per 10

  def self.near (zip_code, distance=100)
    DistanceCalculations.nearby_zip_code(all, zip_code, distance)
  end

  def distance_to (point)
    DistanceCalculations.point_distance([latitude, longitude], [point.latitude, point.longitude])
  end

  def distance_to_latlon(lat, lon)
    Geocoder::Calculations.distance_between([latitude,longitude], [lat,lon])
  end

  def geocode
    zl = Ziplocation.find_and_cache(zip_code)
    write_attribute(:latitude, zl.latitude)
    write_attribute(:longitude, zl.longitude)
  end

  def nonprivate_subscribers
    subscribers
  end

  def has_category_id?(category_id)
    categories.map(&:id).include?(category_id)
  end

  def count_active_campaigns
    campaigns.active.count
  end

  def private_subscribers

  end

  #def self.search (name)
  #  unless name.nil? or name.empty?
  #    where("lower(name) LIKE ?", "%#{name.downcase}%")
  #  else
  #    Kaminari.paginate_array(all)
  #  end
  #end

  def imported_consumers
    Consumer.where(:imported_by => id)
  end

  def to_s
    name
  end

  def short_description
    return "" if description.blank?
    return "#{description[0..136]}..." if description.length > 140
    return description
  end

  def contact_info
    [name, full_address, phone].join("\n")
  end

  def full_address
    [address, city, state, zip_code].join(', ')
  end

  def pretty_address
    "#{address}<br />#{city}, #{state} #{zip_code}"
  end

  def contact_block
    "#{name}<br />#{pretty_address}<br />#{phone}"
  end

  def full_address_changed?
    fields = %w[address city state zip_code]
    (fields & self.changes.keys).any?
  end

  def name_and_address
    [name, "(#{address})"].join(' ')
  end

  def facebook_client_authorized?
    begin
      facebook_access_token? && FbGraph::User.me(facebook_access_token).fetch
    rescue FbGraph::InvalidToken => e
      reset_facebook_credentials
      return false
    end
  end

  def facebook_page_authorized?
    begin
      facebook_client_authorized? and facebook_page_identifier? and facebook_page_access_token? and FbGraph::Page.fetch(facebook_page_identifier, :access_token => facebook_page_access_token)
    rescue FbGraph::InvalidToken => e
      reset_facebook_credentials
      return false
    end
  end

  def facebook_client(redirect_uri = nil)
    @facebook_client ||= facebook_auth(redirect_uri).client
  end

  def facebook_user
    @facebook_user ||= FbGraph::User.me(facebook_access_token).fetch
  end

  def facebook_page
    @facebook_page ||= FbGraph::Page.fetch(facebook_page_identifier, :access_token => facebook_page_access_token)
  end

  def facebook_page_name
    facebook_page.name
  end

  def facebook_page_identifier=(page_id)
    return if page_id.nil? or page_id.empty?
    account = facebook_user.accounts.find{|a| a.identifier == page_id}
    return if account.nil?
    write_attribute(:facebook_page_access_token, account.access_token)
    super(page_id)
  end

  def reset_facebook_credentials
    @facebook_client = @facebook_user = @facebook_page = nil
    reset_facebook_page
    update_attribute(:facebook_access_token, nil)
  end

  def reset_facebook_page
    update_attribute(:facebook_page_access_token, nil)
  end

  def reset_twitter_credentials
    update_attribute(:access_token, nil)
    update_attribute(:secret_token, nil)
  end

  def has_twitter_credentials?
    access_token.present? && secret_token.present?
  end

  def has_facebook_credentials?
    facebook_access_token.present? &&
      facebook_page_identifier.present? &&
      facebook_page_access_token.present?
  end

  def finish_import_callback(consumers)
    HooddittMailer.consumer_import_report(merchant.email, consumers).deliver
  end

  def successful_transactions
    ShoppingCart.find_by_sql("select sc.*
      from shopping_carts sc
      inner join shopping_cart_items sci on sci.owner_id = sc.id and sci.owner_type = 'ShoppingCart'
      inner join coupons co on co.id = sci.item_id and sci.item_type = 'Coupon'
      inner join campaigns ca on ca.id = co.campaign_id
      where
        sc.status = 'success'
        and m.partner_id = #{self.id}
")
  end

  def shopping_cart_items_by_status(status)
    shopping_cart_items.where(owner_id: ShoppingCart.joins(:transactions).where("transactions.status" => status).pluck(:id))
  end

  def monthly_revenue
    revenue_total = 0
    transactions = self.shopping_cart_items_by_status('Success')
    start_date = DateTime.now - 1.month
    end_date = DateTime.now
    filtered_transactions = transactions.where(:created_at => start_date..end_date)
    transactions.each do |transaction|
      revenue = transaction.owner.transactions.last.revenue_per_item * transaction.quantity * self.partner.revenue_share / 100
      revenue_total += revenue
    end
    revenue_total
  end

  # no need to join `consumers` table, use foreign key
  # to check if relationship exists
  def has_subscriber?(consumer)
    subscriptions.collect(&:consumer_id).include?(consumer.id)
  end

  private
  def facebook_auth(redirect_uri = nil)
    @auth ||= FbGraph::Auth.new(
      ENV['FACEBOOK_CONSUMER_KEY'],
      ENV['FACEBOOK_CONSUMER_SECRET'],
    :redirect_uri => redirect_uri)
  end
end
