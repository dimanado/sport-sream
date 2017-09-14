Given /^I am on the consumer signup page$/ do
  visit new_consumer_registration_path
end

Then /^I should be able to enter a email address$/ do
  page.should have_css('input#consumer_email')
end

Then /^I should be able to enter a password$/ do
  page.should have_css('input#consumer_password')
end

Then /^I should have to confirm the password$/ do
  page.should have_css('input#consumer_password_confirmation')
end

Then /^I should be able to enter a birth year$/ do
  page.should have_css('select#consumer_birth_year')
end

Then /^I should be able to enter a location$/ do
  page.should have_css('input#consumer_location')
end

Then /^I should be able to enter a gender$/ do
  page.should have_css('input#consumer_gender_m')
  page.should have_css('input#consumer_gender_f')
end