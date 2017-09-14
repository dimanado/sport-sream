Given /^I have received a coupon via SMS$/ do
  @campaign = Factory(:direct_coupon_campaign, :message_content => "Here it is")
  @campaign.coupon.update_attribute(:content, "My great coupon")
  @message = Factory(:message, :campaign => @campaign)
  @message.deliver!
end

When /^I click on the link in the message$/ do
  visit @message.full_redemption_url
end

Then /^I should see the coupon message$/ do
  page.should have_css("p", :text => "My great coupon")
end

Then /^I should see for which campaign was the coupon$/ do
  page.should have_css(".alert-message.success", :text => @message.campaign.message_content)
end
