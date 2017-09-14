require 'spec_helper'

feature "Creating Merchant with Business" do
  before do
    visit '/'

    within '.greenmenu' do
      click_link "Business Log In"
    end
    click_link "Sign up"

    FactoryGirl.create(:partner)
  end

  scenario "сan create Merchant with usual Business" do
    fill_in 'Business Name *', with: bussiness_name = Faker::Name.name
    fill_in 'Street *', with: Faker::Address.street_address
    fill_in 'City *', with: Faker::Address.city
    select 'Alabama', :from => "State *"
    fill_in 'ZIP Code *', with: Faker::Address.zip_code
    fill_in 'Phone (main number) *', with: Faker::PhoneNumber.phone_number
    fill_in 'Your Name *', with: name = Faker::Name.first_name
    fill_in 'Email *', with: email = Faker::Internet.email

    password = 'password'

    fill_in 'Password *', with: password
    fill_in 'Confirm Password *', with: password

    within '.green_button' do
      find('input[name=commit]').click
    end

    expect(page).to have_content('"success":true', '"redirect":"businesses/')

    visit '/'
    within '.greenmenu' do
      click_link "Business Log In"
    end

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    within '.new_merchant' do
      click_button "Sign in"
    end

    current_path.should == new_campaign_path

    within '.greeting' do
      greeting = "Hi, #{name}, choose your business"
      expect(page).to have_content(greeting)
    end
    expect(page).to have_content("Create a New Offer")

    click_link "My Businesses"
    click_link bussiness_name

    expect(page).to have_content('Business Profile')
    find('.promocode_field', :visible => false).visible?.should == true
  end

  scenario "сan create Merchant with Online Business" do
    fill_in 'Business Name *', with: bussiness_name = Faker::Name.name
    check('Are you online business?')

    select 'Alabama', :from => "State *"
    fill_in 'ZIP Code *', with: Faker::Address.zip_code
    fill_in 'Phone (main number) *', with: Faker::PhoneNumber.phone_number
    fill_in 'Your Name *', with: name = Faker::Name.first_name
    fill_in 'Email *', with: email = Faker::Internet.email

    password = 'password'

    fill_in 'Password *', with: password
    fill_in 'Confirm Password *', with: password

    within '.green_button' do
      find('input[name=commit]').click
    end

    expect(page).to have_content('"success":true', '"redirect":"businesses/')

    visit '/'
    within '.greenmenu' do
      click_link "Business Log In"
    end

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    within '.new_merchant' do
      click_button "Sign in"
    end

    current_path.should == new_campaign_path
    click_link "My Businesses"
    click_link bussiness_name

    expect(page).to have_content('Business Profile')
    find('.promocode_field', :visible => false).visible?.should == false

    click_link 'Create New Offer'

    find('#campaign_coupon_attributes_promo_code', :visible => false).visible?.should == true
  end
end