Given /^I am viewing an indirect coupon$/ do
  @campaign = Factory(:indirect_coupon_campaign)
  @campaign.enqueue!
  @campaign.deliver!
  @message = @campaign.messages.first
  @message.deliver!
  visit view_coupon_path(@message.redemption_code)
end

Then /^I should be able to share the coupon$/ do
  page.should have_css("span.st_facebook_large")
  page.should have_css("span.st_twitter_large")
  page.should have_css("span.st_email_large")
end

Given /^I am viewing a direct coupon$/ do
  @campaign = Factory(:direct_coupon_campaign)
  @campaign.recipients << Factory(:consumer)
  @campaign.enqueue!
  @campaign.deliver!
  @message = @campaign.messages.first
  @message.deliver!
  visit view_coupon_path(@message.redemption_code)
end

Then /^I should not be able to share the coupon$/ do
  page.should_not have_css("span.st_facebook_large")
  page.should_not have_css("span.st_twitter_large")
  page.should_not have_css("span.st_email_large")
end