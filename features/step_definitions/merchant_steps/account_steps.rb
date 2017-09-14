Given /^I have purchased services$/ do
  @current_merchant.account = Factory(:account, :merchant => @current_merchant)
end

When /^I go to the billing history page$/ do
  visit account_path
end

Then /^I should see a table of my past transactions$/ do
  page.should have_css('table#transactions')
end

Then /^I should see a link to update my billing information$/ do
  page.should have_css('a', :text => "update billing info")
end