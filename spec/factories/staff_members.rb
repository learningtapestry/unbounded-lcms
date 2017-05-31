FactoryGirl.define do
  factory :staff_member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
