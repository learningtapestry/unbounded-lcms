class StaffMember < ActiveRecord::Base
  validates :name, presence: true
  validates :bio, length: { maximum: 4096 }
end
