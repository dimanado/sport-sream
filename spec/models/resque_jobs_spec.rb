require "spec_helper"

describe ShareTwitterJob do
    let(:coupon) { create(:coupon) }

    it 'starts background work' do
      pending('to do')
      campaign = coupon.campaign
      business = campaign.business
      ShareTwitterJob.perform(campaign.id, business.id)
      expect(Campaign).to receive(:find_by_id).with(campaign.id)
      expect(Business).to receive(:find_by_id).with(campaign.id)
    end
end