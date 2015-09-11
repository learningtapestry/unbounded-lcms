require 'carrierwave/orm/activerecord'
require 'content/models/concerns/canonicable'
require 'content/uploaders/download_uploader'

module Content
  module Models
    class Download < ActiveRecord::Base
      include Canonicable

      mount_uploader :filename, Content::DownloadUploader
      alias_attribute :file, :filename

      validates :title, :file, presence: true

      before_save :update_metadata

      private
        def update_metadata
          if file.present?
            self.content_type = file.file.content_type
            self.filesize     = file.file.size
          end

          true
        end
    end
  end
end
