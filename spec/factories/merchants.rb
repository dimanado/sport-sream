FactoryGirl.define do
  factory :merchant do
    name "Ostap Ibragim Maria Bender"
    email { Faker::Internet.email }
    password "password"
    is_admin false
    subscription_plan "basic"
  end
end
