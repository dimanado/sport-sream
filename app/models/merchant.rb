class Merchant < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  after_create :update_dispatch_recepient#:send_welcome_email

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
    :businesses_attributes, :is_admin, :subscription_plan, :partner_id
  belongs_to :partner
  has_many :businesses, dependent: :destroy
  has_many :subscribers, through: :businesses
  has_many :campaigns, through: :businesses
  has_many :messages, through: :campaigns
  has_many :shopping_cart_items, through: :businesses
  validates :name, presence: true
  validates_format_of :email, with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  accepts_nested_attributes_for :businesses, reject_if: proc {|attrs| attrs.any?{|k,v| v.blank?} }
  validates_uniqueness_of :email

  # validate :must_have_at_least_one_business, :on => :create

  #def self.search (email)
  #  unless email.nil? or email.empty?
  #    where("lower(email) LIKE ?", "%#{email.downcase}%")
  #  else
  #    Kaminari.paginate_array(all)
  #  end
  #end

  def update_dispatch_recepient
    dispatch_recipient = DispatchRecipient.joins(:dispatch).order("created_at DESC").where("dispatches.partner_id" => self.partner_id, :email => self.email).readonly(false).first
    unless dispatch_recipient.nil?
      dispatch_recipient.update_attributes(status: "confirmed", updated_at: Time.now)
    end
  end

  def send_welcome_email
    HooddittMailer.welcome_merchant(email).deliver
  end

  def is_admin?
    email == ENV['RAILS_ADMIN'] or read_attribute(:is_admin)
  end

  def to_s
    name || email
  end

  def business
    businesses.first
  end

  private

  def must_have_at_least_one_business
    if businesses.empty?
      errors.add(:base, "Must have at least one business")
    end
  end

end
