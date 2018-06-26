# frozen_string_literal: true

FactoryGirl.define do
  factory :content_guide_definition do
    description { Faker::Lorem.sentence }
    keyword { Faker::Lorem.word }
  end
end
