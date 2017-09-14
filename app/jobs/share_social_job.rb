class ShareSocialJob
  @queue = :share
  def self.perform(campaign_id, business_id)
    campaign = Campaign.find_by_id(campaign_id)
    business = Business.find_by_id(business_id)
    return unless campaign.present? or business.present?
    begin
      SocialNetworkShare.share(campaign, business)
    rescue Twitter::Error::TooManyRequests => error
      # TODO
      # log
      Resque.enqueue_at(error.rate_limit.reset_in.from_now ShareSocialJob, @campaign.id, @business.id)
    end
  end
end
