FactoryGirl.define do
  factory :material do
    file_id { "file_#{SecureRandom.hex(6)}" }
  end
end
