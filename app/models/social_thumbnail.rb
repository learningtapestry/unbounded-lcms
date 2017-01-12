class SocialThumbnail < ActiveRecord::Base
  mount_uploader :image, SocialThumbnailUploader

  belongs_to :target, polymorphic: true

  validates :target, :media, :image, presence: true
  validates :media, inclusion: { in: %w{all facebook twitter pinterest} }
end
