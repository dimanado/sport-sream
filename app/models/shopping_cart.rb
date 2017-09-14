class ShoppingCart < ActiveRecord::Base
  acts_as_shopping_cart

  belongs_to :partner
  belongs_to :consumer
  has_many :transactions

  def tax_pct
    0
  end

  def quantity
    shopping_cart_items.map(&:quantity).sum
  end
end
