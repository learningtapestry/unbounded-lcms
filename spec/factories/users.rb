FactoryGirl.define do
  factory :user do
    admin false
    name 'Unbounded User'
    password '12345678'
    password_confirmation '12345678'
    sequence(:email) { |n| "email#{n}@test.com" }

    factory :admin do
      name 'Admin User'
      admin true
    end
  end
end
