FactoryGirl.define do
  factory :alignment, class: Content::Models::Alignment do
    name { Faker::Lorem.sentence }
  end
end
