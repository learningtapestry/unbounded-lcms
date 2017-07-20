FactoryGirl.define do
  factory :resource do
    curriculum_directory ['ela', 'grade 2', 'module 1', 'unit 1', 'lesson 1']
    curriculum_type 'lesson'
    resource_type Resource.resource_types[:resource]
    title 'Test Resource'
    tree true
    url 'Resource URL'

    trait :grade do
      curriculum_directory ['ela', 'grade 2']
      curriculum_type 'grade'
    end

    trait :module do
      curriculum_directory ['ela', 'grade 2', 'module 1']
      curriculum_type 'module'
    end
  end
end
