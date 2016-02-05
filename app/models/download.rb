class Download < ActiveRecord::Base
  mount_uploader :filename, DownloadUploader
  alias_attribute :file, :filename

  validates :title, presence: true
  validates :file, presence: true, if: 'url.nil?'
  validates :url, presence: true, if: 'file.nil?'

  before_save :update_metadata

  def update_filename(filename)
    write_attribute(:filename, filename)
  end

  private
    def update_metadata
      if file.present?
        self.content_type = file.file.content_type
        self.filesize     = file.file.size
      end

      true
    end
end
