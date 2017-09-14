require 'spec_helper'
describe "admin page" do
  it "logs in as an admin and create partner" do
    user = FactoryGirl.create(
            :partner,
            :role => "admin",
            :name => "Random",
            :email => "random_partner@example.com",
            :password => "11111111",
            :zip => '12345',
            :phone => '00000000')

    visit "/admin/login"
    fill_in "partner[email]", :with => "random_partner@example.com"
    fill_in "partner[password]", :with => "11111111"
    find('#partner_submit_action input').click

    expect(page).to have_selector("#current_user a", :text => "Random")
    expect(page).to have_selector('a[href="/admin/partners"]')
    visit "/admin/partners/new"
    expect(page).to have_selector('#page_title', :text => "New Partner")
    fill_in "partner[email]", :with => "another_random_partner@example.com"
    fill_in "partner[name]", :with => "another_random_partner"
    fill_in "partner[slug]", :with => "another_random_partner_slug"
    fill_in "partner[zip]", :with => "12345"
    fill_in "partner[phone]", :with => "00000000"

    find('#partner_submit_action input').click
    expect(page).to have_selector('.flash_notice', :text => "Partner was successfully created.")
  end
end
