class CopyrightAttribution < ActiveRecord::Base
  belongs_to :resource

  validates :resource_id, :value, presence: true
end
