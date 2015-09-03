FactoryGirl.define do
  factory :language, class: Content::Models::Language do
    name { Faker::Lorem.characters(2) }
  end
end
