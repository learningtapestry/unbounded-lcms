FactoryGirl.define do
  factory :subject, class: Content::Models::Subject do
    name { Faker::Lorem.sentence }
  end
end
