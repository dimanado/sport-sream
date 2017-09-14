require "spec_helper"

feature "Shopping Cart Page" do
  let!(:coupon) {create :coupon, subject: "Good Times"}
  let!(:consumer) { create :consumer }

  before(:each) do
    visit '/category/all-offers/'
    within ".coupon.offerboard" do
      expect(page).to have_content("Good Times")
    end

    click_link "Add to cart $1"
    expect(page).to have_content("Shopping Cart")
    within ".cart-table" do
      expect(page).to have_content("Good Times")
    end

    visit '/consumers/sign_in'
    expect(page).to have_content("Customer Login")
    fill_in('consumer[email]', :with => "test@bk.com")
    fill_in('consumer[password]', :with => "12345678") 

    find('.button').click
    expect(page).to have_content("Offer Board")
  end

  scenario "Checkout offer whis PayPal" do

    visit '/shopping_cart'
    find(".pay_pal_button").click
    expect(current_url).to have_content("http://www.example.com/consumers/transactions/new_paypal")

  end
end