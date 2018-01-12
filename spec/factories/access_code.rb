# frozen_string_literal: true

FactoryGirl.define do
  factory :access_code do
    sequence(:code) { |n| "code#{n}" }
  end
end
