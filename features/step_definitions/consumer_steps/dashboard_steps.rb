Given /^I am a registered consumer$/ do
  @current_consumer = Factory(:consumer, :password => "foobar")
  visit new_consumer_session_path
  within "#new_consumer" do
    fill_in "Email", :with => @current_consumer.email
    fill_in "Password", :with => @current_consumer.password
    click_button "Sign in"
  end
end

When /^I go to the consumer dashboard$/ do
  visit consumers_dashboard_path
end

Then /^I should see the coupon table$/ do
  page.should have_css("table#coupons")
end

Given /^I have received some coupons$/ do
  @campaign = Factory(:direct_coupon_campaign)
  @campaign.recipients << @current_consumer
  Account.any_instance.stubs(:record_component_usage)
  @campaign.enqueue!
  DeliverCampaignJob.perform(@campaign, @campaign.message_ids)
end

Then /^I should see the business' name$/ do
  page.should have_css('td', :text => @campaign.business.name)
end

Then /^I should see the coupon expiration dates$/ do
  page.should have_css('td', :text => I18n.localize(@campaign.expires_at))
end

Then /^I should see the coupon's subject$/ do
  page.should have_css('td', :text => @campaign.coupon.subject)
end

Then /^I should see a link to view the coupon$/ do
  message = @current_consumer.messages.select { |m| m.campaign == @campaign }.first
  page.should have_link("view", :href => view_coupon_path(message.redemption_code))
end
