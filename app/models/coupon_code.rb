class CouponCode < ActiveRecord::Base
  #belongs_to :consumer
  #belongs_to :coupon

  before_create :generate_code
  before_create :get_transaction_date
  after_create :increase_sold_count

  PRICE_PER_COUPON = 1

  def self.quantities
    (1..5).map {|q| ["#{q} for $#{(q * PRICE_PER_COUPON).round(2)}", q] }
  end

  def price
    coupon.price
  end

  def redeem!
    update_attribute(:redeemed, true)
  end

  def transaction
   # @transaction ||= Chargify::Transaction.find(self.transaction_id)
  end

  def generate_code
    t = transaction
    self.code = Digest::SHA1.hexdigest([rand.to_s, t.created_at, t.amount_in_cents].join('--'))[0..5]
  end

  def increase_sold_count
    coupon.increase_sold_count!
  end

  def purchased_at
    return purchase_date if !purchase_date.nil?
    fetch_and_save_date
  end

  def get_transaction_date
    purchase_date = transaction.created_at
  end

  private

  def fetch_and_save_date
    update_attribute(:purchase_date, get_transaction_date)
    purchase_date
  end

end
