FactoryGirl.define do
  factory :coupon do
    campaign
    
    subject "Sample Coupon"
    content "Get this sample coupon and make some fun"
    amount -1

    ignore do
      zip_code "10010"
      latitude 0.0
      longitude 0.0
    end

    after(:create) do |coupon, evaluator|
      coupon.campaign.business.tap do |b|
        b.zip_code = evaluator.zip_code
        b.latitude = evaluator.latitude
        b.longitude = evaluator.longitude
        b.save! unless b.new_record?
      end
    end
  end
end
