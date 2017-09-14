When /^I am subscribed to a business$/ do
  step "I am not subscribed to a business"
  @business.subscribers << @current_consumer
end

When /^I am not subscribed to a business$/ do
  @business = @businesses.first
end

When /^I go to the business' info page$/ do
  visit consumers_business_path(@business)
end

Then /^I should see a heading with the business' name$/ do
  page.should have_css("h2", :text => @business.name)
end

Then /^I should see the business' contact information$/ do
  page.should have_css("address", :text => @business.contact_info)
end

Then /^I should see a link to the business' website$/ do
  page.should have_css("a[href='#{@business.website}']")
end

Then /^I should be able to unsubscribe from the business$/ do
  within "#business_#{@business.id}" do
    page.should have_css("a", :text => "Unsubscribe")
  end
end

Then /^I should be able to subscribe to the business$/ do
  within "#business_#{@business.id}" do
    page.should have_css("a", :alt => "Subscribe")
  end
end

Then /^I should see a description of the business$/ do
  page.should have_css("p", :text => @business.description)
end
