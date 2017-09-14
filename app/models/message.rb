class Message < ActiveRecord::Base
  after_create :store_shortened_url

  belongs_to :campaign
  has_one :business, :through => :campaign
  belongs_to :recipient, :class_name => "Consumer"

  validate :campaign, :presence => true
  validate :recipient, :presence => true

  scope :redeemable, where(:state => 'redeemable')

  state_machine :state, :initial => :passive do
    state :passive
    state :delivered
    state :failed
    state :expired

    event :deliver do
      transition :passive => :delivered
    end

    event :expire do
      transition any => :expired
    end
  end

  def deliver
    puts "  entering deliver "
    return unless self.recipient
    if self.recipient && self.recipient.message_delivery_preference == DeliveryChannel::Email.to_s
      send_email(self, self.recipient)
    end
    #super
  end
  
  def send_email(message, recipient)
    @response = HooddittMailer.subscriber_new_coupon(message, recipient).deliver
  end

  def full_redemption_url
    campaign.coupon.redemption_url
  end

  def redemption_url
   URI.join(Shortener.url, campaign.coupon.code).to_s
  end

  def content
    content = ""
    content << campaign.message_content.dup
    content << " "
    content << redemption_url
    content
  end

  def expired?
    campaign.expires_at? && Time.zone.now >= campaign.expires_at
  end

  def delivery_method
    campaign.delivery_method.to_sym
  end

  private

  def store_shortened_url
    Shortener.store(full_redemption_url, campaign.coupon.code)
  end
end
