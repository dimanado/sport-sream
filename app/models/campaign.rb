class Campaign < ActiveRecord::Base
  belongs_to :business, :touch => true
  has_one :merchant, :through => :business

  has_one :coupon, :dependent => :destroy
  accepts_nested_attributes_for :coupon

  has_many :hashtags, :through => :coupon

  has_many :orders
  has_many :messages, :dependent => :destroy
  has_many :recipients, :through => :messages, :class_name => "Consumer"
  has_many :shopping_cart_items, through: :coupon

  has_one :partner, through: :business

  attr_accessible :coupon_attributes, :deliver_at, :expires_at

  validates :message_content, :presence => true
  validates :deliver_at, :presence => true

  has_attachment :image, accept: [:jpg, :png, :gif]

  default_scope where("deleted_at IS NULL")

  scope :passive, where(:state => 'passive').order("deliver_at ASC")
  scope :queued, where(:state => 'queued').order("deliver_at ASC")
  scope :delivered, where(:state => 'delivered').order("deliver_at DESC")

  scope :by_partner, ->(p_id) { joins(business: :merchant ).where(merchants: { partner_id: p_id })}

  state_machine :initial => :passive do
    state :passive
    state :queued
    state :delivered
    state :expired

    after_transition :passive => :queued, :do => :create_messages
    after_transition any => :queued, :do => :enqueue_delivery

    event :enqueue do
      transition all => :queued
    end

    event :deliver do
      transition :queued => :delivered
    end

    event :expire do
      transition all => :expired
    end
  end

  def self.delivered_or_expired
    where('state = ? OR state = ?', 'delivered', 'expired')
  end

  def self.sorted
    order('deliver_at')
  end

  def self.active
    delivered.where('expires_at > ?', Time.zone.now)
  end

  def has_recipient? (consumer)
    messages.where(:recipient_id => consumer.id).size > 0
  end

  def sent_to? (consumer)
    messages.where(:recipient_id => consumer.id).size > 0
  end

  def delivered?
    state == 'delivered'
  end

  def to_s
    self.class.name
  end

  def editable?
    ["passive", "queued"].include?(state)
  end

  def enqueue_delivery
    puts "  entering enqueue_delivery  "
    puts "  id #{id}  "
    puts "  message_ids #{message_ids}  "

    Resque.remove_delayed(DeliverCampaignJob, id, message_ids)
    Resque.enqueue_at(deliver_at, DeliverCampaignJob, id, message_ids)
    Resque.remove_delayed(ExpireCampaignJob, id, message_ids)
    Resque.enqueue_at(expires_at, ExpireCampaignJob, id, message_ids)
  end

  def views
    messages.reduce(0) { |count, message| count += message.viewed_count }
  end

  def redemptions
    messages.reduce(0) { |count, message| count += message.redeemed_count }
  end

  def description
    coupon.subject
  end

  def description?
    description.present?
  end

  def cost
    return 0
  end

  def matched_email_consumers
    return [] if matched_consumers.empty?
    matched_consumers
  end

  def matched_consumers
    matches = business.nonprivate_subscribers
    if matches
      return matches
    else
      return []
    end
  end

  def matched_consumer_count
    matched_consumers.uniq.size
  end

  def create_messages
    puts "  entering create_messages  "
    matched_consumers.each do |consumer|
      messages.create(:recipient => consumer)
    end
  end

  def message_content
    "#{business.nil? ? "Unknown Business" : business.name} is sending you an offer from Dollarhood!"
  end

  def sales
    transactions = []
    transactions
  end

  def shopping_cart_items_by_status(status)
    shopping_cart_items.where(owner_id: ShoppingCart.joins(:transactions).where("transactions.status" => status).pluck(:id))
  end


  def total_revenue
    revenue_total = 0
    transactions = self.shopping_cart_items_by_status('Success')
    transactions.each do |transaction|
      revenue = transaction.owner.transactions.last.revenue_per_item * transaction.quantity * self.partner.revenue_share / 100
      revenue_total += revenue
    end
    revenue_total
  end

  def has_available_coupon?
    not has_unavailable_coupon?
  end

  # copy of coupon.unavailable?
  # prevent extra query for campaign from coupon.unavailable?
  def has_unavailable_coupon?
    return false if coupon.new_record?
    Time.zone.now > expires_at || coupon.sold_count == coupon.amount
  end

end
