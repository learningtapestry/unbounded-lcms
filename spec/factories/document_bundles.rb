# frozen_string_literal: true

FactoryGirl.define do
  factory :document_bundle do
    category { DocumentBundle::CATEGORIES.sample }
    content_type { DocumentBundle::CONTENT_TYPES.sample }
    resource
  end
end
