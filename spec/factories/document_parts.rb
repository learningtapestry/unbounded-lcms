FactoryGirl.define do
  factory :document_part do
    document nil
    content "MyText"
    part_type "MyString"
    active false
    parent nil
  end
end
