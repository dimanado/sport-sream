class Coupon < ActiveRecord::Base
  before_create :create_code
  belongs_to :campaign, :touch => true
  has_one :business, :through => :campaign
  has_one :partner, :through => :campaign

  has_many :shopping_cart_items, as: :item

  has_and_belongs_to_many :hashtags

  
  validates_presence_of :subject, :content
  validates_length_of :subject, :maximum => 255

  attr_accessible :amount, :subject, :content, :address, :sold_count, :terms, :thumb, :business_id, :more_terms, :promo_code 

  has_attachment :image, accept: [:jpg, :png, :gif]
  scope :by_partner, ->(p_id) { joins(campaign: [{ business: :merchant }]).where(merchants: { partner_id: p_id })}

  serialize :terms

  def increase_sold_count!
    transaction do
      unless unlimited? or unavailable?
        self.sold_count += 1
        self.save
      end
    end
  end

  def has_image?
    thumb != ''
  end

  def image_url
    thumb
  end

  def unavailable?
    return false if new_record?
    Time.zone.now > campaign.expires_at || sold_count == amount
  end

  def unavailable_buy? quantity
    left = amount - sold_count
    left >= quantity
  end

  def available?
    not unavailable?
  end

  def unlimited?
    amount == -1
  end

  def redemption_url
    Rails.application.routes.url_helpers.view_coupon_url(code, :host => ActionMailer::Base.default_url_options[:host])
  end

  def terms
    super || []
  end

  def terms=(value)
    super(value.reject(&:blank?))
  end

  def address
    super || (business && business.address)
  end

  private

  def create_code
    self.code = Shortener.code
  end

end
