FactoryGirl.define do
  factory :user, class: Content::Models::User do
    email    { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :admin, parent: :user do
    after(:create) do |user|
      role = Content::Models::Role.find_or_create_by!(name: 'admin')
      user_role = Content::Models::UserRole.new(organization: Content::Models::Organization.unbounded, role: role)
      user.user_roles << user_role
    end
  end
end
