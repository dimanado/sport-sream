FactoryGirl.define do
  factory :campaign do
    business

    message_content "This is some really valuable message content"
    deliver_at 1.hour.ago
    expires_at 28.days.from_now
  end
end
