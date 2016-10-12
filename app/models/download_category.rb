class DownloadCategory < ActiveRecord::Base
  has_many :resource_downloads

  validates :name, uniqueness: true, presence: true
end
