require "spec_helper"

feature "Publicly accessible pages" do
  let!(:coupon) {create :coupon, subject: "Good Times"}

  scenario "Browsing from homepage" do
    visit '/'
    expect(page).to have_content("All Offers")

    click_link "All Offers"
    within ".coupon.offerboard" do
      expect(page).to have_content("Good Times")
    end

    click_link "View Details"
    within ".coupon-detail" do
      expect(page).to have_content("Good Times")
    end
  end
end
