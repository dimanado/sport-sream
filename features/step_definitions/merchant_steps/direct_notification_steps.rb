When /^I go to the new direct notification page$/ do
  visit new_direct_notification_campaign_path
end

Then /^I should not be able to create a coupon$/ do
  page.should_not have_css("#coupon-creator")
end