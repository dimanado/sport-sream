class DeliverCampaignJob
  @queue = :campaign

  def self.perform(campaign_id, message_ids)
    puts "  DeliverCampaignJob perform  "
    puts "  campaign_id #{campaign_id}  "
    puts "  message_ids #{message_ids}  "

    campaign = Campaign.find(campaign_id)
    message_ids.each do |message_id|
      message = campaign.messages.find(message_id)
      begin
        message.deliver!
      rescue Exception => e
        p e
      end
    end

    begin
      campaign.deliver!
    rescue Exception => e
      p e
      #campaign.redeliver! # try to deliver the campaign one more time
    end
  end
end
