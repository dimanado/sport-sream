class Consumer < ActiveRecord::Base
  FIELDS = [:first_name, :last_name, :phone, :website, :company, :fax, :addresses, :credit_cards, :custom_fields]

  #before_save :reset_authentication_token, :if => :encrypted_password_changed?
  before_save :send_confirmation_email, :if => "email_changed? and not new_record?"

  #after_create :send_welcome_email
  after_create :autosubscribe_to_matt

  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :category_ids, :gender, :location, :mobile, :birth_year,
    :email, :password, :password_confirmation,
    :remember_me, :referral_code, :referral_id, :weekly_digest,
    :imported_by, :latitude, :longitude,
    :provider, :uid

  attr_reader :distance

  has_one :account, :class_name => 'ConsumerAccount'

  has_many :messages, :foreign_key => "recipient_id"
  has_many :subscriptions
  has_many :favorites, :through => :subscriptions, :source => :business
  has_many :shopping_carts

  has_many :transactions

  #has_many :coupon_codes

  belongs_to :referral

  validates :email, presence: true, format: {:with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}
  validates :location, :presence => true, :on => :create
  validates_format_of :location, :with => /^\d{5}(-\d{4})?$/
  validates_uniqueness_of :email

  paginates_per 10


  attr_accessor *FIELDS
  attr_accessible :email, :password, :password_confirmation, :remember_me, :braintree_customer_id

  def has_payment_info?
    !!braintree_customer_id
  end

  def with_braintree_data!
    return false unless has_payment_info?

    begin
      braintree_data = Braintree::Customer.find(braintree_customer_id)
    rescue Braintree::NotFoundError => bang
      self.braintree_customer_id = nil
      self.save!
      return false
    end

    FIELDS.each do |field|
      send(:"#{field}=", braintree_data.send(field))
    end
    self
  end

  def default_credit_card
    return unless has_payment_info?

    credit_cards.find { |cc| cc.default? }
  end

  def distance_to (point)
    DistanceCalculations.point_distance([latitude, longitude], [point.latitude, point.longitude])
  end

  def self.near (zip_code, distance=100, all)
      DistanceCalculations.nearby_zip_code_offers(all, zip_code, distance)
  end

  def offers_count
    offers.count
  end

  def offers
    active_messages.map {|m| m.campaign }
  end

  def all_offers
    Campaign
      .includes(:coupon)
      .includes(:business => [:logo_files, :categories])
      .where('expires_at > ?', Time.zone.now)
      .where('deliver_at < ?', Time.zone.now)
      .select {|c| c.coupon.amount != 0 }
  end

  def all_offers_board
    Campaign.where('expires_at > ?', Time.zone.now)
      .where('deliver_at < ?', Time.zone.now)
      .select {|c| c.coupon.amount != 0; c.business.merchant.is_admin? }
  end

  def active_messages
    messages.select {|m| m.campaign.expires_at > Time.zone.now }
  end

  def charged_for? (coupon)
    account.charged_for?(coupon) rescue false
  end

  def autosubscribe_to_matt
    m = Merchant.where(:email => 'matt.balin@chinoki.com').first
    if m
      m.businesses.first.subscribers << self
    end
  end

  def convert_from_private!
    update_attribute(:type, 'Consumer')
  end

  def bought? (coupon)
    account.bought?(coupon) rescue false
  end

  def self.search (email)
    unless email.nil? or email.empty?
      where("lower(email) LIKE ?", "%#{email.downcase}%")
    else
      Kaminari.paginate_array(all)
    end
  end

  def confirmation_token
    Digest::SHA1.hexdigest(email)
  end

  def unsubscribe_from_weekly_digest
    update_attribute :weekly_digest, false
  end

  def send_weekly_email
    HooddittMailer.consumer_weekly(email).deliver if weekly_digest?
  end

  def send_confirmation_email
    self.email_confirmed = false
    HooddittMailer.consumer_confirmation(email).deliver
  end

  def self.registered_from (date)
    where("created_at >= ?", date)
  end

  def self.registered_by_day (from_date)
    result = count(:all, :conditions => ["created_at >= ?", from_date],
                         :group => "DATE(created_at)")
    result.default = 0
    result
  end

  def age
    Date.today.year - birth_year
  end

  def send_welcome_email
    HooddittMailer.welcome_consumer(email).deliver
  end

  def interesting_indirect_messages
    interesting_businesses.map(&:active_indirect_messages).flatten.uniq
  end

  def subscribed_to?(business)
    subscriptions.exists?(:business_id => business.id)
  end

  def to_s
    email
  end

  def authenticatable_salt
    HoodittEncryptor.salt
  end

  def password_digest(password)
    HoodittEncryptor.digest(password, 1, authenticatable_salt, nil)
  end

  def valid_password?(password)
    begin
      HoodittEncryptor.compare(encrypted_password, password, 1, authenticatable_salt, nil)
    rescue Exception => e
      p e
      return false
    end
  end

  def self.has_provider?(consumer)
    consumer.provider.present?
  end

  def needs_reverse_geocoding?
    (latitude_changed? or longitude_changed?) and location.nil?
  end

  def as_json(options = {})
    super(:methods => "authentication_token")
  end

  def self.facebook_post_to_wall(fields)
    graph = Koala::Facebook::API.new(fields.credentials.token)
    graph.put_wall_post("#{fields.extra.raw_info.name} just signed up for Dollarhood!! Dollarhood allows you to save money while shopping at businesses in your neighborhood - Dollarhood supports local businesses!", {:link => "http://www.dollarhood.com"})
  end

  def self.find_for_facebook_oauth(auth)
    cur_email = auth.info.email.present? ? auth.info.email : "#{auth.uid}@facebook.com"
    consumer = self.where(email: cur_email).first
    unless consumer
      consumer = self.create(name:auth.extra.raw_info.name,
                                 provider:auth.provider,
                                 uid:auth.uid.to_s,
                                 email:cur_email,
      )
      consumer.save!(validate:false)
      self.facebook_post_to_wall(auth)

    end
    unless self.has_provider?(consumer)
      consumer.uid = auth.uid.to_s
      consumer.provider = auth.provider
      consumer.save!
    end
    consumer
  end

  def last_shopping_cart
    shopping_carts.where("status != ?", '').order(:created_at).last
  end

  private

    def reset_message_delivery_preference
      self.message_delivery_preference = 'DeliveryChannel::Email'
    end

end