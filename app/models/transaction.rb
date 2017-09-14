class Transaction < ActiveRecord::Base

  attr_accessible :braintree_transaction_id
  belongs_to :shopping_cart
  has_many :shopping_cart_items, through: :shopping_cart
  belongs_to :consumer

  def express_token=(token)
    write_attribute(:express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end

  def revenue_per_item
    revenue = 0
    unless self.amount.blank?
      amount = self.amount
      n = (amount / 1).round
      unless self.payment_processor.blank?
        if self.payment_processor == "Braintree"
          amount_cut = amount - 0.30
          revenue = amount_cut - ((amount_cut * 2.9) / 100)
          revenue_per_item = revenue / n
        elsif self.payment_processor == "Paypal"
          amount_cut = amount - 0.05
          revenue = amount_cut - ((amount_cut * 5) / 100)
          revenue_per_item = revenue / n
        else
          revenue_per_item = 0
        end
      end

    end
    revenue_per_item
  end

  def confirmation_code
    code = 'NaN'

    unless self.id.nil?
      unless self.shopping_cart.nil?
        code = self.braintree_transaction_id || self.paypal_transaction_id || self.id
      else
        code = self.id
      end
    end
    code
  end

  def payment_processor
    if self.paypal_transaction_id.present?
      payment_processor = "Paypal"
    else
      payment_processor = "Braintree"
    end

    payment_processor
  end  
end
