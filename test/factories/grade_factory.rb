FactoryGirl.define do
  factory :grade, class: Content::Models::Grade do
    grade { Faker::Lorem.sentence }
  end
end
