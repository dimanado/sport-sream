class ShareFacebookJob
  @queue = :share

  def self.perform(campaign_id, business_id)
    puts "  ShareFacebookJob perform  "
    puts "  campaign_id #{campaign_id}  "
    puts "  business_id #{business_id}  "
    tries = 0
    campaign = Campaign.find_by_id(campaign_id)
    business = Business.find_by_id(business_id)
    coupon = campaign.coupon
    begin
      tries += 1
      SocialNetworkShare.share_facebook(campaign, business, coupon)
      puts 'SENDED FACEBOOK SHARE'
    rescue Koala::Facebook::AuthenticationError => error
    puts "  AuthenticationError => STOP  "
    rescue Exception => e
      puts "  Error: #{e.inspect}  "
      if tries <= 3
        puts "  Try to resend (#{tries}/3)  "
        retry
      else
        puts " STOP PERFORMING "
      end
    end
  end
end