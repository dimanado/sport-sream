Given /^I am on the merchant dashboard$/ do
  step "I am a signed in merchant"
  visit dashboard_path
end

Then /^I should see the direct or indirect message campaign selection$/ do
  with_scope("buttons") {
    page.should have_content("Direct Message Campaign")
  }
end

When /^I choose "([^"]*)"$/ do |name|
  click_link(name)
end

Then /^I should see the form$/ do
  page.should have_xpath("//form")
end

Then /^I should be able to target registered consumers$/ do
  page.should have_css("#recipient-selector")
end

Then /^I should be able to preview the default message$/ do
  page.should have_css(".preview")
  page.should have_content("is sending you a coupon from chinoki! Redeem it:")
end

Then /^I should be able to create a new coupon campaign$/ do
  page.should have_link("Direct Coupon", :href => new_direct_campaign_path(:campaign => {:delivery_channel_class_names => ["DeliveryChannel::Email","DeliveryChannel::Sms"]}))
  page.should have_link("Twitter Coupon", :href => new_indirect_campaign_path(:campaign => {:delivery_channel_class_names => ["DeliveryChannel::Twitter"]}))
  page.should have_link("Facebook Coupon", :href => new_indirect_campaign_path(:campaign => {:delivery_channel_class_names => ["DeliveryChannel::Facebook"]}))
end

Then /^I should be able to create a new notification campaign$/ do
  page.should have_link("SMS Message", :href => new_direct_notification_campaign_path(:campaign => {:delivery_channel_class_names => ["DeliveryChannel::Email","DeliveryChannel::Sms"]}))
end

When /^I should be able to schedule delivery of the campaign$/ do
  page.should have_css("#active-date-range")
end

Then /^I should see the coupon creator$/ do
  page.should have_css("#coupon-creator")
  page.should have_css("input[type=hidden]#campaign_coupon_attributes_color_scheme")
  page.should have_css("input#campaign_coupon_attributes_image")
  page.should have_css("textarea#campaign_coupon_attributes_content")
  page.should have_css("ul#terms")
  page.should have_css("input#campaign_coupon_attributes_subject")
  page.should have_css("textarea#campaign_coupon_attributes_address")
end

When /^I supply the redemption code of the coupon$/ do
  fill_in "code", :with => @message.redemption_code
  click_button "Submit"
end

Then /^I should see the cost of sending the campaign$/ do
  page.should have_css("#campaign-cost")
end

Then /^I should see how many people have viewed the coupon$/ do
  page.should have_css("#coupon_views")
end

Then /^I should see how many people have redeemed the coupon$/ do
  page.should have_css("#coupon_redemptions")
end

Then /^I should see the demographic breakdown of users to whom the campaign was delivered$/ do
  page.should have_css("#recipient_demographics")
end

When /^I go to the delivered campaigns page$/ do
  visit delivered_campaigns_path
end

When /^I go to the scheduled campaigns page$/ do
  visit scheduled_campaigns_path
end

Then /^I should see a list of the delivered campaigns$/ do
  page.should have_css("table#campaigns")
  @delivered_campaigns.each do |campaign|
    page.should have_link("stats", :href => polymorphic_path(campaign, :action => :statistics))
  end
end
