class ReceivesChargifyHooks

  def self.receive(event, payload)
    return unless valid_payload?(event, payload)

    consumer = ConsumerAccount.where(:subscription_id => payload[:subscription][:id]).first.consumer rescue nil
    json = payload[:transaction][:memo].split('Payment for:').last
    memo = JSON.parse(json)
    coupon = Coupon.find_by_id(memo['coupon_id']) rescue nil

    if consumer and coupon and !coupon.unavailable?
      codes = []
      quantity = memo['quantity'].to_i
      quantity.times do
        codes << CouponCode.new({
          :coupon_id => coupon.id,
          :consumer_id => consumer.id,
          :transaction_id => payload[:transaction][:id]
        })
      end
      send_codes codes.select(&:save)
      coupon.id
    else
      p "Ignoring invalid coupon hook payload"
      p consumer
      p coupon
      nil
    end
  end

  def self.valid_payload?(event, payload)
    transaction = payload[:transaction]
    return invalid_payload('is nil') if payload.empty?
    return invalid_payload('transaction kind is not onetime') if transaction[:kind] != 'one_time'
    return invalid_payload('event is not payment_success') if event != 'payment_success'
    return invalid_payload('transaction type is not Payment') if transaction[:type] != 'Payment'
    return invalid_payload('has not JSON data attached in memo') if transaction[:memo].split('Payment for:').size < 2

    true
  end

  private

  def self.send_codes (codes)
    codes.each do |code|
      HooddittMailer.consumer_coupon_code(code).deliver
    end
  end

  def self.invalid_payload(message)
    p 'payload ' + message
    false
  end

end
