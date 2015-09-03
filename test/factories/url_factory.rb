FactoryGirl.define do
  factory :url, class: Content::Models::Url do
    url { Faker::Internet.url }
  end
end
