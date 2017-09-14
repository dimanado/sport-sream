class ShowsSalesForCoupon

  def self.group_by_consumer_for (coupon)
    # date | email | codes | payment 
    #
    # create hash email => coupon_codes
    data = {}
    coupon.coupon_codes.each do |cc|
      email = cc.consumer.email
      data[email] ||= []
      data[email] << cc
    end
    data
  end

  def self.generate (coupon)
    data = group_by_consumer_for(coupon)
    result = []
    data.each do |email, coupon_codes|
      result << generate_entry(email,coupon_codes)
    end
    result.sort {|a,b| a[:date] <=> b[:date] }
  end

  private

  def self.generate_entry (email, coupon_codes)
    coupon_price = coupon_codes.first.price

    {
      :date => coupon_codes.first.purchased_at,
      :email => email,
      :codes => coupon_codes.map(&:code),
      :payment => coupon_price * coupon_codes.size
    }
  end

end
