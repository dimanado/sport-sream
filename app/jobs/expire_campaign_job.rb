class ExpireCampaignJob
  @queue = :campaign

  def self.perform(campaign_id, message_ids)
    campaign = Campaign.find(campaign_id)
    message_ids.each do |message_id|
      message = campaign.messages.find(message_id)
      message.expire!
    end
    campaign.expire!
  end
end
