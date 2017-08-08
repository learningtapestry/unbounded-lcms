# frozen_string_literal: true

class DocumentPart < ActiveRecord::Base
  belongs_to :document

  enum context_type: { default: 0, gdoc: 1 }

  default_scope { active }

  scope :active, -> { where(active: true) }
end
