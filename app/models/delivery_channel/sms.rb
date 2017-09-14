class DeliveryChannel::Sms < DeliveryChannel::Indirect
  def self.human_name
    "SMS"
  end

  def self.chop (message_content)
    msg_split = message_content.split(/\ https?:\/\//)
    
    #Chopping the message part (besides the link) which exceeds 115 chars
    if msg_split.size > 1
      available_length = 115 - 9 - msg_split[1].size
      delta = available_length - msg_split[0].size

      message = delta > 0 ? message_content : [msg_split[0][0..delta-4] + '...', msg_split[1]].join(' http://')
    else
      delta = 115 - message_content.size
      message = delta > 0 ? message_content : message_content[0..delta-4] + '...'
    end

    message
  end

  def attempt_delivery(message)
    return unless message.recipient
    if message.recipient && message.recipient.mobile && message.recipient.message_delivery_preference == DeliveryChannel::Sms.to_s
      Rails.logger.info("sending SMS message: #{message.recipient.id}\n#{message.content}\n")
      deliver(message.recipient.mobile, message.content)
    end
  end

  def sent?
    @response && @response["stat"] == "ok"
  end

  def deliver(mobile_number, message_content)
    message = self.class.chop(message_content)

    Rails.logger.info(" sending SMS message to #{mobile_number}:\n#{message}\n")
    @response ||= sms(mobile_number, message).deliver_sms
    unless sent?
      errors = @response['errors'].join("\n")
      Rails.logger.warn("Error sending SMS message to #{mobile_number}:\n#{message_content}\n#{errors}")
      raise Moonshado::Sms::MoonshadoSMSException.new("#{errors}")
    end
  end

  private
    def sms(mobile_number, message_content)
      @sms ||= Moonshado::Sms.new(mobile_number, message_content)
    end
end
