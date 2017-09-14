Given /^the system contains some businesses$/ do
  @businesses = []
  5.times do
    @businesses << Factory(:business)
  end
end

When /^I go to the businesses index page$/ do
  visit consumers_businesses_path
end

Then /^I should see a list of the chinoki businesses$/ do
  page.should have_css("table#businesses")
  @businesses.each do |business|
    page.should have_css("td", :text => business.name)
    page.should have_css("td", :text => business.full_address)
    page.should have_css("td", :text => business.short_description)
  end
end

Then /^I should be able to search for a business by name$/ do
  page.should have_css("input#business_name")
end

Then /^I should be able to filter by subscribed status$/ do
  page.should have_css("select#subscription_filter")
end