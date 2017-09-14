Given /^I am on the merchant registration page$/ do
  visit new_merchant_registration_path
end

When /^I provide the required information$/ do
  within "#new_merchant" do
    fill_in 'Name',                        :with => 'Test Testerson'
    fill_in 'Email',                       :with => 'test@appren.com'
    fill_in 'Password',                    :with => 'password1'
    fill_in 'Confirm Password',       :with => 'password1'
    step "I edit the business information"
    click_button 'Complete Sign Up'
  end
end

Given /^I am a signed in merchant$/ do
  @current_merchant = Factory(:merchant)
  visit new_merchant_session_path
  within "#new_merchant" do
    fill_in 'Email', :with => @current_merchant.email
    fill_in 'Password', :with => "password1"
    click_button "Sign in"
  end
  current_path.should == dashboard_path
end

Given /^I have created some campaigns$/ do
  unless @current_merchant
    step %{I am a signed in merchant}
  end
  4.times {
    campaign = Factory(:direct_coupon_campaign, :business => @current_merchant.businesses.first)
    campaign.enqueue!
  }
  4.times {
    campaign = Factory(:indirect_coupon_campaign, :business => @current_merchant.businesses.first)
    campaign.enqueue!
  }
end

Given /^a consumer has received my coupon and presents it to me$/ do
  step "I am a signed in merchant"
  campaign = Factory(:direct_coupon_campaign, :business => @current_merchant.businesses.last)
  campaign.enqueue!
  @message = Factory(:message, :campaign => campaign)
  @message.deliver!
end

When /^I go to the coupon redemption page$/ do
  visit redeem_coupon_path
end

Then /^I should see that it is valid$/ do
  page.should have_content("valid")
end

Given /^I have some subscribers for my business$/ do
  step "I am a signed in merchant"
  @business = @current_merchant.businesses.first
  5.times {
    @business.subscribers << Factory(:consumer)
  }
end

When /^I follow "([^"]*)" from the left nav$/ do |link_name|
  within "#left-nav" do
    click_link link_name
  end
end

Then /^I should see (\d+) businesses in my business selector$/ do |number_of_businesses|
  page.should have_css('select#business_id option', :count => number_of_businesses.to_i)
end
