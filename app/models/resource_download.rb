class ResourceDownload < ActiveRecord::Base
  belongs_to :resource
  belongs_to :download
  belongs_to :download_category

  validates :download, presence: true

  accepts_nested_attributes_for :download
end
