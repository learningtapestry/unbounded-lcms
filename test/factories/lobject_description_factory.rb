FactoryGirl.define do
  factory :lobject_description, class: Content::Models::LobjectDescription do
    description { Faker::Lorem.sentence(50) }
  end
end
