class DeliveryChannel::Twitter < DeliveryChannel::Indirect

  def attempt_delivery(message)
    Rails.logger.info("sending Twitter message: \n#{message.content}\n")
    business = message.campaign.business
    @twitter_client = TwitterClient.new(business.access_token,
                                        business.secret_token)

    @twitter_client.update(message.content) if @twitter_client.authorized?
  end

  def sent?
    @response["error"].nil?
  end
end
