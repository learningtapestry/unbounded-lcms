# frozen_string_literal: true

FactoryGirl.define do
  factory :download do
    title { Faker::Lorem.words.join '' }
    url { Faker::Internet.url }
  end
end
