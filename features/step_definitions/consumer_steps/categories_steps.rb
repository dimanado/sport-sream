When /^I go to the consumer interests page$/ do
  visit consumers_categories_path
end

Then /^I should be able to choose which categories of products interest me$/ do
  page.should have_css("div[id=categories_selector]")
end