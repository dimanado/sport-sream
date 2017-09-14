class DeliveryChannel::Facebook < DeliveryChannel::Indirect

  def attempt_delivery(message)
    Rails.logger.info("sending Facebook message: \n#{message.content}\n")
    @response = message.campaign.business.facebook_page.feed!(
     :message => message.content,
     :link => "#{ TODO ADD LINK INFO }",
     :name => message.campaign.business.name,
     :description => message.campaign.business.name
   )
  end

  def sent?
    true # TODO: Perhaps interrogate the response for something useful? 
  end
end
