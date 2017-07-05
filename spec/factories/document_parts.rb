FactoryGirl.define do
  factory :document_part do
    document nil
    content 'MyText'
    part_type 'layout'
    active true
  end
end
