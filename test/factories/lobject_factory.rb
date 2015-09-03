FactoryGirl.define do
  factory :lobject, class: Content::Models::Lobject do
    after(:create) do |lobject|
      create_list(:lobject_alignment, 1, lobject: lobject)
      create_list(:lobject_grade, 1, lobject: lobject)
      create_list(:lobject_description, 1, lobject: lobject)
      create_list(:lobject_language, 1, lobject: lobject)
      create_list(:lobject_resource_type, 1, lobject: lobject)
      create_list(:lobject_subject, 1, lobject: lobject)
      create_list(:lobject_title, 1, lobject: lobject)
      create_list(:lobject_topic, 1, lobject: lobject)
      create_list(:lobject_url, 1, lobject: lobject)
    end
  end
end
