# frozen_string_literal: true

Resource.class_eval do
  has_many :content_guides, through: :unbounded_standards
end
