FactoryGirl.define do
  factory :resource do
    curriculum_directory ['ela', 'grade 2', 'module 1', 'unit 1', 'lesson 1']
    curriculum_tree
    curriculum_type 'lesson'
    resource_type Resource.resource_types[:resource]
    title 'Test Resource'
    url 'Resource URL'
  end
end
