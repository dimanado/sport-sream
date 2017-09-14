Given /^I have configured social apis for my business$/ do
  Business.any_instance.stubs(:facebook_page_authorized?).returns(true)
  Business.any_instance.stubs(:twitter_client_authorized?).returns(true)
end

When /^I click on an indirect campaign$/ do
  @campaign = @current_merchant.indirect_campaigns.queued.first
  within dom_id(@campaign) do
    click_link("edit")
  end
end

When /^I should be able to provide message content$/ do
  page.should have_css("#campaign_message_content")
end

When /^I go to the indirect campaign creation page$/ do
  visit new_indirect_campaign_path
end

Then /^the indirect delivery channels should be disabled$/ do
  page.should have_css("input#campaign_delivery_channel_class_names_deliverychannelfacebook[disabled]")
  page.should have_css("input#campaign_delivery_channel_class_names_deliverychanneltwitter[disabled]")
end

Then /^I should be able to select indirect delivery channels$/ do
  page.should have_css("input[value='DeliveryChannel::Facebook']")
  page.should have_css("input[value='DeliveryChannel::Twitter']")
end
