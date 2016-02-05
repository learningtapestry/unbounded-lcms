class DownloadCategory < ActiveRecord::Base
  has_many :resource_downloads
end
