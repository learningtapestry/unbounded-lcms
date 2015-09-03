FactoryGirl.define do
  factory :resource_type, class: Content::Models::ResourceType do
    name { Faker::Lorem.sentence }
  end
end
