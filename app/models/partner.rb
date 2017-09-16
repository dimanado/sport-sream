class Partner < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  validates :slug, :presence => true, :uniqueness => true, :format => { with: /^[a-zA-Z0-9_]*$/, message: "allows only alphanumeric characters" }, :length => { in: 4..20 }
  validates :zip, :presence => true
  validates :phone, :presence => true
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :slug, :url, :contact_info, :revenue_share, :phone, :address, :city, :zip, :state
  has_many :merchants
  has_many :campaigns, through: :merchants
  has_many :shopping_carts
  has_many :shopping_cart_items, through: :merchants

  has_many :dispatches
  has_many :material, through: :dispatches

  # after_create { |admin| admin.send_welcome_partner }

  def self.default_partner
    find_or_create_by_name 'Dollarhood'
  end

  def self.dollarhood
    find_by_slug('dollarhood')
  end

  def is_dollarhood?
    slug == "dollarhood"
  end

  def send_welcome_partner
    @email = self.email
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    self.save(:validate => false)
    @reset_password_token = raw
    HooddittMailer.welcome_partner(@email, @reset_password_token).deliver
  end

  # setting up roles
  # The order of the ROLES array is important!
  # All privileges are inherited from left to right
  ROLES = %w(partner admin)

  # Privileges are inherited between roles in the order specified in the ROLES
  # array. E.g. A moderator can do the same as an editor + more.
  #
  # This method understands that and will therefore return true for moderator
  # users even if you call `role?('editor')`.
  def role?(base_role)
    return false unless role # A user have a role attribute. If not set, the user does not have any roles.
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def password_required?
    new_record? ? false : super
  end

  def shopping_cart_items_by_status(status)
    shopping_cart_items.where(owner_id: ShoppingCart.joins(:transactions).where("transactions.status" => status).pluck(:id))
  end

  def all_shopping_cart_items_by_status(status)
    ShoppingCartItem.where(owner_id: ShoppingCart.joins(:transactions).where("transactions.status" => status).pluck(:id))
  end

  def revenue_per_item(payment_processor)
    if payment_processor == "Braintree"
      cut = 0.32
    end
    if payment_processor == "Paypal"
      cut = 0.1
    end
    (1 - cut) * self.revenue_share / 100
  end


  def all_offers
    Campaign.by_partner(self.id)
    .includes(:coupon)
    .includes(:business => [:logo_files, :categories])
    .where('expires_at > ?', Time.zone.now)
    .where('deliver_at < ?', Time.zone.now)
    .select {|c| c.coupon.amount != 0 }
  end



end
