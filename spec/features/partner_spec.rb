require 'spec_helper'
describe "admin page" do
	  it "logs in as a partner" do
    user = FactoryGirl.create(:partner, :name => "Random", :email => "random_partner@example.com", :password => "11111111", :address => "4499 John Daniel Drive", :city => "Jefferson City", :state => "MO", :zip => "65109", :phone => "573-673-5641", :contact_info => "Mike")
    visit "/"
    expect(page).to have_selector('footer a[href="/admin/login"]')
    visit "/admin/login"
    fill_in "partner[email]", :with => "random_partner@example.com"
    fill_in "partner[password]", :with => "1111111"
    find('#partner_submit_action input').click

    expect(page).to have_selector('.flash', :text => "Invalid email or password.")

    fill_in "partner[email]", :with => "random_partner@example.com"
    fill_in "partner[password]", :with => "11111111"
    find('#partner_submit_action input').click
    
    expect(page).to have_selector('a[href="' + edit_admin_partner_path(user) + '"]')
    expect(page).to have_selector('a[href="' + admin_partner_path(user) + '"]')
    expect(page).to have_content("Total businesses")
    expect(page).to have_content("Daily revenue")
    expect(page).to have_selector('#tabs a[href="/admin/dashboard"]')
    expect(page).to have_selector('#tabs a[href="/admin/campaigns"]')
    expect(page).to have_selector('#tabs a[href="/admin/businesses"]')
    expect(page).to have_selector('#tabs a[href="/admin/revenue"]')
    expect(page).to have_selector('#tabs a[href="/admin/help"]')

    visit "/admin/businesses"
    merchant = FactoryGirl.create(:merchant, :partner_id => 1, :name => "Random_merchant", :email => "random_merchant@example.com", :password => '11111111')
    business = FactoryGirl.create(:business, :merchant_id => 1, :name => "Random_business", :location => "12345")

    expect(page).to have_selector('h2#page_title', :text => "Businesses")
    expect(page).to have_content('Random')

    visit "/admin/partners/new"
    expect(page).to have_selector('.flash', :text => "You are not authorized to perform this action.")
  end
end

#create partner, check letter, go to letter link, fill password, go to dashboard
#change password
#check daily revenue and total businesses count