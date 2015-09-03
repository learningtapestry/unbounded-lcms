FactoryGirl.define do
  factory :topic, class: Content::Models::Topic do
    name { Faker::Lorem.sentence }
  end
end
