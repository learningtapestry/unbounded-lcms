require 'google/apis/drive_v3'

class ContentGuide < ActiveRecord::Base
  extend OrderAsSpecified
  include Search::ResourcesSearch

  attr_accessor :update_metadata

  has_many :content_guide_standards
  has_many :common_core_standards, ->{ where(type: 'CommonCoreStandard') }, source: :standard, through: :content_guide_standards
  has_many :resources, through: :unbounded_standards
  has_many :standards, through: :content_guide_standards
  has_many :unbounded_standards, ->{ where(type: 'UnboundedStandard') }, source: :standard, through: :content_guide_standards

  validates :date, :description, :grade, :subject, :teaser, :title, presence: true, if: :validate_metadata?

  before_save :process_content, unless: :update_metadata

  mount_uploader :big_photo, ContentGuidePhotoUploader
  mount_uploader :small_photo, ContentGuidePhotoUploader

  scope :where_subject, ->(subjects) {
    subjects = Array.wrap(subjects)
    if subjects.any? then where(subject: subjects) else where(nil) end
  }

  scope :where_grade, ->(grades) {
    grades = Array.wrap(grades)
    if grades.any? then where(grade: grades) else where(nil) end
  }

  class << self
    def file_id_from_url(url)
      url.scan(/\/d\/([^\/]+)\//).first.first rescue nil
    end

    def import(file_id, credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials

      file = service.get_file(file_id, fields: 'lastModifyingUser,modifiedTime,name,version')
      content = service.export_file(file_id, 'text/html').encode('ASCII-8BIT').force_encoding('UTF-8')

      cg = find_or_initialize_by(file_id: file_id)
      cg.update!(name: file.name,
                  last_modified_at: file.modified_time,
                  last_modifying_user_email: file.last_modifying_user.email_address,
                  last_modifying_user_name: file.last_modifying_user.display_name,
                  original_content: content,
                  version: file.version)
      cg
    end
  end

  def modified_by
    "#{last_modifying_user_name} <#{last_modifying_user_email}>" if last_modifying_user_name.present?
  end

  def original_url
    "https://docs.google.com/document/d/#{file_id}/edit"
  end

  def validate_metadata
    @validate_metadata = true
    valid?
  end

  private

  def assign_common_core_standards(value)
    names = split_standards(value)
    self.common_core_standards = CommonCoreStandard.where(name: names)
  end

  def assign_unbounded_standards(value)
    names = split_standards(value)

    unbounded_standards.where.not(name: names).each do |standard|
      content_guide_standards.find_by_standard_id(standard.id).delete
    end

    names.each do |name|
      standard = UnboundedStandard.create_with(subject: '').find_or_create_by(name: name)
      unbounded_standards << standard if standard && !unbounded_standards.include?(standard)
    end
  end

  def download_images(doc)
    doc.css('img').each do |img|
      url = img[:src]
      if (image = (ContentGuideImage.create_with(remote_file_url: url).find_or_create_by!(original_url: url)))
        img[:src] = image.file.url
      end
    end
    doc
  end

  def extract_links(doc)
    doc.css('a[href^="https://www.google.com/url"]').each do |a|
      url = URI(a[:href])
      params = Rack::Utils.parse_query(url.query)
      a[:href] = params['q']
      a[:target] = '_blank'
    end
    doc
  end

  def process_content
    doc = Nokogiri::HTML(original_content)
    body_str = doc.xpath('/html/body/*').to_s
    body = Nokogiri::HTML.fragment(body_str)
    body = download_images(body)
    body = extract_links(body)
    body = process_metadata(body)
    self.content = body.to_s
  end

  def process_metadata(doc)
    table = doc.at_css('table')
    return doc unless table

    table.css('tr').each do |tr|
      key, value = tr.css('td').map(&:content).map(&:strip)
      case key
      when 'ccss' then assign_common_core_standards(value)
      when 'related_instruction_tags' then assign_unbounded_standards(value)
      when 'big_photo', 'small_photo' then send("remote_#{key}_url=", value)
      else send("#{key}=", value)
      end
    end

    table.remove
    doc
  end

  def split_standards(value)
    value.split(',').map(&:strip).map(&:downcase)
  end

  def validate_metadata?
    !!@validate_metadata
  end
end
