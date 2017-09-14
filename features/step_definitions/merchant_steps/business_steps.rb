When /^I visit a business profile$/ do
  @business = @current_merchant.businesses.first
  visit edit_business_path(@business)
end

Then /^I should be able to edit the profile$/ do
  page.should have_css("form input[type=submit]")
  attach_file "Logo", "spec/fixtures/beverly-hills-logo.jpg"
  step "I edit the business information"
end

When /^I edit the business information$/ do
  fill_in 'business_name',        :with => 'appRen'
  fill_in 'business_address',     :with => '309 Cherry St'
  fill_in 'business_city',        :with => 'Philadelphia'
  fill_in 'business_zip_code',    :with => '19108'
  fill_in 'business_phone',       :with => '(215)-828-6161'
  check "business_category_ids_#{@category.children.first.id}"
  select 'Pennsylvania', :from => 'business_state'
end

When /^I press "([^"]*)"$/ do |button|
  click_button button
end

Then /^I should be on the business profile page$/ do
  page.current_path.should == edit_business_path(@business)
end