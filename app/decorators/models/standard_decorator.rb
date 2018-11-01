# frozen_string_literal: true

Standard.class_eval do
  has_many :content_guide_standards, dependent: :destroy
  has_many :content_guides, through: :content_guide_standards
end
