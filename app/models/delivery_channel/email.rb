class DeliveryChannel::Email < DeliveryChannel::Direct

  def attempt_delivery(message)
    puts "  entering attempt_delivery "
    return unless message.recipient
    if message.recipient && message.recipient.message_delivery_preference == DeliveryChannel::Email.to_s
      deliver(message, message.recipient)
    end
  end

  def deliver(message, recipient)
    @response = HooddittMailer.message_coupon(message, recipient).deliver
  end

  def sent?
    @response && @response.has_message_id?
  end
end
