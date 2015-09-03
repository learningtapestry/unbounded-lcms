FactoryGirl.define do
  factory :organization, class: Content::Models::Organization do
    name { Faker::Company.name }
  end
end
