class CopyrightAttribution < ActiveRecord::Base
  belongs_to :curriculum

  validates :curriculum_id, :value, presence: true
end
