require 'spec_helper'

feature "Create an offer" do
  before do
    visit '/'

    within '.greenmenu' do
      click_link "Business Log In"
    end
    click_link "Sign up"

    FactoryGirl.create(:partner)

    fill_in 'Business Name *', with: @bussiness_name = Faker::Name.name
    fill_in 'Street *', with: Faker::Address.street_address
    fill_in 'City *', with: @city = Faker::Address.city
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
  end

  scenario "can create an offer with promocode" do
    click_link @bussiness_name
    fill_in 'business[name]', with: business_name = Faker::Name.name
    check('Online business')
    fill_in 'business[zip_code]', with: Faker::Address.zip_code
    fill_in 'business[phone]', with: Faker::PhoneNumber.phone_number
    fill_in 'business[website]', with: web_site = Faker::Internet.domain_name

    click_button "Save"
    select business_name, :from => "business_id"

    click_link "Create New Offer"
    current_path.should == new_campaign_path

    fill_in 'campaign[coupon_attributes][subject]', with: title = Faker::Lorem.sentence
    fill_in 'Offer Content', with: content = Faker::Lorem.paragraph
    fill_in 'campaign[coupon_attributes][promo_code]', with: Faker::PhoneNumber.phone_number

    click_button('Finished. Add to Queue', disabled: true)

    visit '/category/all-offers/'
    within '.coupon' do
      expect(page).to have_content(web_site)
      expect(page).to have_content(business_name)
      expect(page).to have_content(title)
    end

    click_link "View Details"
    expect(page).to have_content(title)
    expect(page).to have_content(business_name)
    within '.product_text' do
      expect(page).to have_content(web_site)
    end
  end

  scenario "can create an offer without promocode" do
    click_link @bussiness_name
    fill_in 'business[name]', with: business_name = Faker::Name.name
    uncheck('Online business')
    fill_in 'business[address]', with: address = Faker::Address.street_name
    select 'Alabama', :from => "State"
    state = 'AL'
    fill_in 'business[zip_code]', with: Faker::Address.zip_code
    fill_in 'business[phone]', with: Faker::PhoneNumber.phone_number
    fill_in 'business[website]', with: web_site = Faker::Internet.domain_name

    click_button "Save"
    select business_name, :from => "business_id"

    click_link "Create New Offer"
    current_path.should == new_campaign_path

    fill_in 'campaign[coupon_attributes][subject]', with: title = 1
    fill_in 'Offer Content', with: content = Faker::Lorem.paragraph
    fill_in 'campaign[coupon_attributes][address]', with: Faker::Address.street_address

    click_button('Finished. Add to Queue', disabled: true)

    visit '/category/all-offers/'
    within '.coupon' do
      expect(page).to have_content(@city +", "+ state)
      expect(page).to have_content(business_name)
      expect(page).to have_content(title)
    end

    click_link "View Details"
    expect(page).to have_content(title)
    expect(page).to have_content(business_name)
    within '.product_text' do
      expect(page).to have_content(address)
    end
  end
end