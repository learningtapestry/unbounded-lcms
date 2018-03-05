# frozen_string_literal: true

FactoryGirl.define do
  factory :setting, class: 'Settings' do
    data { { editing_enabled: true } }
  end
end
