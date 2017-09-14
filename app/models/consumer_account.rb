class ConsumerAccount < ActiveRecord::Base
  belongs_to :consumer

  def subscription

  end

  def transactions (kind)
    @transactions ||= {}
    @transactions[kind] ||= subscription.transactions({
      :kinds => [kind],
      :success => true
    })
  end

  def bought? (coupon)
    CouponCode.where(:consumer_id => consumer.id, :coupon_id => coupon.id).size > 0
  end

  def charged_for? (coupon)
    transactions('charge').map do |t|
      JSON.parse(t.memo)['coupon_id'] rescue 0
    end.include?(coupon.id)
  end

  def payment_transactions_json_memo
    transactions('payment').map do |t|
      data = JSON.parse(t.memo.split('Payment for:').last) rescue {}
      [t.id, data]
    end
  end

  def pending_purchase? (coupon)
    #is there a charge memo which doesn't have a matching payment memo?
    #return true if charged_for?(coupon)
    payment_data = payment_transactions_json_memo
    p payment_data
    return false if payment_data.empty?
    coupon_transactions = payment_data.select {|e| e.last['coupon_id'] == coupon.id }
    return false if coupon_transactions.empty?
    transaction_id = coupon_transactions.last[0]
    p transaction_id
    code = CouponCode.where(:consumer_id => consumer.id,
                            :coupon_id => coupon.id,
                            :transaction_id => transaction_id).first

    code.nil?
  end

  def edit_link
    "https://#{Chargify.subdomain}.chargify.com/update_payment/#{subscription_id}/#{update_token}"
  end

  def self.chargify_signup_link_for(consumer)
    [
      chargify_gateway,
      "email=#{consumer.email}&reference=#{consumer.id}&billing_zip=#{consumer.location}"
    ].join('?')
  end

  def update_token
    token('update_payment')
  end

  private
    def self.chargify_gateway
      "https://#{Chargify.subdomain}.chargify.com/h/#{chargify_product_id}/subscriptions/new"
    end

    def self.chargify_product_id
      case Chargify.subdomain
      when 'chinoki-development'
        '1780460'
      when 'chinoki-test'
        '1782114'
      when 'chinoki-final'
        '2233709'
      when 'chinoki-staging'
        '1780459'
      end
    end

    def token(page_name)
      Digest::SHA1.hexdigest([page_name, subscription_id, Chargify.shared_api_key].join("--"))[0..9]
    end
end
