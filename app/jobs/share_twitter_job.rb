class ShareTwitterJob
  @queue = :share

  def self.perform(campaign_id, business_id)
    puts "  ShareTwitterJob perform  "
    puts "  campaign_id #{campaign_id}  "
    puts "  business_id #{business_id}  "
    campaign = Campaign.find_by_id(campaign_id)
    business = Business.find_by_id(business_id)
    coupon = campaign.coupon
    begin
      SocialNetworkShare.share_twitter(campaign, business, coupon)
      puts " SENDED TWITTER SHARE "
    rescue Twitter::Error::TooManyRequests => error
      puts "  TooManyRequests error  "
      puts "  Delayed for #{error.rate_limit.reset_in} seconds  "
      Resque.enqueue_at(error.rate_limit.reset_in.from_now, ShareTwitterJob, campaign_id, business_id)
    rescue Exception => e
      puts " UNKNOWN ERROR "
      puts e.inspect
    end
  end
end
