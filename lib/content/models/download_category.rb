module Content
  module Models
    class DownloadCategory < ActiveRecord::Base
      has_many :lobject_downloads
    end
  end
end
