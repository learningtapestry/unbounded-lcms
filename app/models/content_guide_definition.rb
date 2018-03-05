# frozen_string_literal: true

class ContentGuideDefinition < ActiveRecord::Base
  validates :keyword, :description, presence: true
  validates :keyword, uniqueness: true
end
