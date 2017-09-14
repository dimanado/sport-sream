class SocialNetworkShare
  def self.start_jobs(campaign, business)
    if business.has_twitter_credentials? && campaign.twitter_share.present?
      Resque.enqueue(ShareTwitterJob, campaign.id, business.id)
    end
    if business.has_facebook_credentials? && campaign.facebook_share.present?
      Resque.enqueue(ShareFacebookJob, campaign.id, business.id)
    end
  end

  def self.share_twitter(campaign, business, coupon)
    twitter_client = TwitterClient.new(business.access_token, business.secret_token, true)
    twit_length = 95
    twit_length -= business.name.length + 3
    twit_content = coupon.subject.length > 95 ? coupon.subject.slice(0..twit_length-3) + "..." : coupon.subject
    status = business.name + " - " + twit_content + " - via @dollarhoodUS " + "http://dollarhood.com/coupons/" + coupon.code
    # options = { lat: business.latitude, long: business.longitude }
    tweet = twitter_client.update(status)
  end

  def self.share_facebook(campain, business, coupon)
    facebook_client = Koala::Facebook::GraphAPI.new(business.facebook_page_access_token)
    post = facebook_client.put_wall_post( "#{business.name} started new offer!", {
      "name" => coupon.subject,
      "link" => "http://dollarhood.com/coupons/" + coupon.code,
      "caption" => "Dollarhood.com",
      "description" => coupon.content,
      "picture" => coupon.thumb
    })
  end
end