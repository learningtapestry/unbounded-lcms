# frozen_string_literal: true

class AccessCode < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :by_code, ->(value) { active.where('lower(code) = ?', value.downcase) }
end
