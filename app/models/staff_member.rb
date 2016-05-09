class StaffMember < ActiveRecord::Base
  validates :name, presence: true
  validates :bio, length: { maximum: 4096 }
  enum staff_type: { staff: 1, board: 2 }

  scope :order_by_name, -> { order(:name) }
  #mount_uploader :image_file, StaffImageUploader
end
