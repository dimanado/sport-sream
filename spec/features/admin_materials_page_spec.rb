require "spec_helper"

feature "Materials page on the admin panel" do
  before do
    create(
      :partner,
      name: "Random",
      email: "random_partner@example.com",
      password: 'password',
      role: 'admin'
    )

    visit "/admin/login"
    fill_in "partner[email]", with: "random_partner@example.com"
    fill_in "partner[password]", with: "password"
    find('#partner_submit_action input').click
    # save_and_open_page
    expect(page).to have_selector("#current_user a", :text => "Random")
    expect(page).to have_selector('a[href="/admin/partners"]')

    visit "/admin/materials"
  end

  scenario "Visit the materials page" do
    # save_and_open_page
    expect(page).to have_selector('#page_title', :text => "Materials")
  end

  scenario "Create  material" do
    click_link "New Material"
    expect(current_path).to eq new_admin_material_path
    fill_in 'Title', with: 'TEST MATERIAL'
    select 'image', :from => "Type of file*"
    attach_file 'material_file', "#{Rails.root}/spec/fixtures/central_phone.png"
    click_on 'Create Material'
    expect(page).to have_content("Material was successfully created.")
    visit "/admin/materials"
    expect(page).to have_content("TEST MATERIAL")
  end


end