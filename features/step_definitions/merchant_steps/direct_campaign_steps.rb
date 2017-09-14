When /^I click on a direct campaign$/ do
  @campaign = @current_merchant.direct_campaigns.queued.first
  within dom_id(@campaign) do
    click_link("edit")
  end
end

When /^I go to the direct campaign creation page$/ do
  visit new_direct_campaign_path
end

Then /^I should be able to select direct delivery channels$/ do
  page.should have_css("input#campaign_delivery_channel_class_names_deliverychannelemail")
  page.should have_css("input#campaign_delivery_channel_class_names_deliverychannelsms")
end

Then /^the direct delivery channels should be disabled$/ do
  page.should have_css("input#campaign_delivery_channel_class_names_deliverychannelsms[disabled]")
  page.should have_css("input#campaign_delivery_channel_class_names_deliverychannelemail[disabled]")
end

Then /^I should be able to edit that campaign$/ do
  current_url.should == edit_direct_campaign_url(@campaign)
  step 'I should see the form'
end
