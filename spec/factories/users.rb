FactoryGirl.define do
  factory :user do
    admin false
    password '12345678'
    password_confirmation '12345678'
    sequence(:email) { |n| "email#{n}@test.com" }

    factory :admin do
      admin true
    end
  end
end
