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

  def attachment_url
    if url.present?
      url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
    else
      file.url
    end
  end

  def attachment_content_type
    case content_type
    when 'application/zip' then 'zip'
    when 'application/pdf' then 'pdf'
    when 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' then 'excel'
    when 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation' then 'powerpoint'
    when 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' then 'doc'
    else content_type
    end
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
