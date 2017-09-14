Given /^I have confirmed my mobile number$/ do
  @current_consumer.mobile_confirmed_at = Time.now
  @current_consumer.save!
end

Given /^I am awaiting a mobile confirmation token$/ do
  @current_consumer.mobile = FactoryGirl.generate(:mobile)
  @current_consumer.save!
end

When /^I go to the consumer profile page$/ do
  visit edit_consumer_path
end

Then /^I should be able to choose my preferred way to receive messages from businesses$/ do
  page.should have_css("input#consumer_message_delivery_preference_deliverychannelemail")
  page.should have_css("input#consumer_message_delivery_preference_deliverychannelsms")
end

Then /^I should be able to update my location$/ do
  page.should have_css("input#consumer_location")
end

Then /^I should be able to input my mobile number$/ do
  page.should have_css("input#consumer_mobile")
end

Then /^I should be able to enter my mobile confirmation code$/ do
  page.should have_css("input#confirmation_code")
end

Then /^I should be able to request a redelivery of the mobile confirmation token$/ do
  page.should have_link("resend confirmation code", :href => consumers_send_mobile_confirmation_token_path)
end
