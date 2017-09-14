include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :material do
    title { Faker::Name.title }
    type_of_file "image"
    file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'central_phone.png'), 'image/png') }
  end
end
