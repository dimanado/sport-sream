class EmitsCouponPurchase

  def self.emit (consumer_account, coupon, qty)
    quantity = qty.to_i
    status, error = ensure_valid_data(consumer_account, coupon, quantity)
    return [status, error] unless status

    consumer = consumer_account.consumer
    campaign = coupon.campaign
    join_campaign(consumer,campaign) unless campaign.has_recipient?(consumer)

    charge_data = build_charge(coupon, quantity)

    if not consumer_account.pending_purchase?(coupon)
      begin
        consumer_account.subscription.charge charge_data
        return [true, 'The coupon was bought']
      rescue Exception => e
        #raise e unless e.class.ancestors.include?(ActiveResource)
        Airbrake.notify(e)
        return [false, 'Inactive or invalid subscription']
      end
    else
      [false, 'Another purchase is pending']
    end
  end

  def self.build_charge (coupon, quantity)
    memo = {:quantity => quantity, :coupon_id => coupon.id}.to_json
    {
      :amount => coupon.price * quantity,
      :memo => memo
    }
  end

  def self.ensure_valid_data (account, coupon, quantity)
    return [false, 'You do not have a subscription'] unless account
    return [false, 'Invalid coupon'] unless coupon
    return [false, 'Quantity can not be less than 1'] unless quantity > 0
    return [false, 'Coupon is not available'] unless coupon.available?

    if coupon.amount < quantity and not coupon.unlimited?
      return [false, 'You can not buy coupons more than are available']
    end

    [true, nil]
  end

  private

  def self.join_campaign (consumer, campaign)
    campaign.messages.create(:recipient => consumer)
  end

end
