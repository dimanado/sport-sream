require "spec_helper"

describe ApplicationController do

  describe "Geocoding" do
    controller do
      def index
        generate_entries(Campaign.all)
        render nothing: true
      end
    end

    it "remembers ip and coordinates in a cookie" do
      ENV['RAILS_TEST_IP_ADDRESS'] = "1.1.1.1"
      get :index
      c = JSON.parse(cookies[:ip_geocoding_cookie])
      expect(c).to eql({"coordinates" => [0.0, 0.0], "ip" => "1.1.1.1"})
    end

    it "sorts offers by distance to consumer" do
      distant_coupon = create(:coupon, latitude: 0, longitude: 10)
      nearby_coupon = create(:coupon, latitude: 0, longitude: 5)
      get :index
      expect(assigns[:offers]).to eql([nearby_coupon, distant_coupon].map(&:campaign))
    end
  end
end
