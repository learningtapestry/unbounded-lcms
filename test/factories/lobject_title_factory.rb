FactoryGirl.define do
  factory :lobject_title, class: Content::Models::LobjectTitle do
    title { Faker::Lorem.sentence }
  end
end
