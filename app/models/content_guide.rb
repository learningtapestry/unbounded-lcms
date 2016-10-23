require 'google/apis/drive_v3'

class ContentGuide < ActiveRecord::Base
  extend OrderAsSpecified
  include Searchable

  GRADES = ['prekindergarten', 'kindergarten', 'grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5', 'grade 6', 'grade 7', 'grade 8', 'grade 9', 'grade 10', 'grade 11', 'grade 12']
  ICON_VALUES = %w(complexity instruction volume)

  attr_accessor :update_metadata

  acts_as_taggable_on :grades

  has_many :content_guide_standards
  has_many :common_core_standards, ->{ where(type: 'CommonCoreStandard') }, source: :standard, through: :content_guide_standards
  has_many :resources, through: :unbounded_standards
  has_many :standards, through: :content_guide_standards
  has_many :unbounded_standards, ->{ where(type: 'UnboundedStandard') }, source: :standard, through: :content_guide_standards

  validates :date, :description, :subject, :teaser, :title, presence: true, if: :validate_metadata?
  validates :permalink, format: { with: /\A\w+\z/ }, uniqueness: { case_sensitive: false }
  validate :icon_values
  validate :media_exist
  validate :no_broken_ext_links

  before_validation :process_content, unless: :update_metadata
  before_validation :downcase_permalink
  before_save :set_slug

  mount_uploader :big_photo, ContentGuidePhotoUploader
  mount_uploader :pdf, ContentGuidePdfUploader
  mount_uploader :small_photo, ContentGuidePhotoUploader

  scope :where_subject, ->(subjects) {
    subjects = Array.wrap(subjects)
    if subjects.any? then where(subject: subjects) else where(nil) end
  }

  scope :where_grade, ->(value) {
    value = Array.wrap(value)
    return where(nil) unless value.any?

    joins(taggings: [:tag])
    .where(taggings: { context: 'grades' })
    .where(tags: { name: value })
  }

  delegate :broken_ext_links, :tasks_without_break, to: :presenter

  class << self
    def file_id_from_url(url)
      url.scan(/\/d\/([^\/]+)\/?/).first.first rescue nil
    end

    def import(file_id, credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials

      file = service.get_file(file_id, fields: 'lastModifyingUser,modifiedTime,name,version')
      content = service.export_file(file_id, 'text/html').encode('ASCII-8BIT').force_encoding('UTF-8')

      cg = find_or_initialize_by(file_id: file_id)
      cg.attributes = {
        name: file.name,
        last_modified_at: file.modified_time,
        last_modifying_user_email: file.last_modifying_user.email_address,
        last_modifying_user_name: file.last_modifying_user.display_name,
        original_content: content,
        version: file.version
      }
      cg.save
      cg
    end

    def sort_by_grade
      includes(taggings: :tag).sort_by(&:grade_score)
    end
  end

  def grade_score
    indices =
      taggings.map do |t|
        grade = t.tag.name if t.context == 'grades'
        GRADES.index(grade)
      end.compact

    [indices.min || 0, indices.size]
  end

  def modified_by
    "#{last_modifying_user_name} <#{last_modifying_user_email}>" if last_modifying_user_name.present?
  end

  def non_existent_podcasts
    @non_existent_podcasts ||= begin
      presenter.podcast_links.map { |a| a[:href] }.select do |url|
        !Resource.find_podcast_by_url(url)
      end
    end
  end

  def non_existent_videos
    @non_existent_videos ||= begin
      presenter.video_links.map { |a| a[:href] }.select do |url|
        !Resource.find_video_by_url(url)
      end
    end
  end

  def original_url
    "https://docs.google.com/document/d/#{file_id}/edit"
  end

  def paragraphs_with_invalid_icons
    @paragraphs_with_invalid_icons ||= begin
      presenter.icons.map do |icon|
        icon.parent unless ICON_VALUES.include?(icon['data-value'])
      end.compact
    end
  end

  def pdf_title
    base_title = title.gsub(/[^[[:alnum:]]]/, '_').gsub(/_+/, '_')
    "#{base_title}_v#{version}"
  end

  def pdf_version
    v = pdf.url.split('_').last
    if v.start_with?('v')
      v[1..-1].to_i
    end
  end

  def pdf_refresh?
    pdf.blank? || pdf_version != version
  end

  # If PDF is stale, refresh it using a remote URL
  def pdf_refresh!(new_pdf_url)
    if pdf_refresh?
      self.remote_pdf_url = new_pdf_url
      save!
    end
  end

  # "Fuzzy" CG identificator
  def permalink_or_id
    if permalink.present?
      permalink
    else
      id
    end
  end

  def sorted_grade_list
    grade_list.sort_by { |g| GRADES.index(g) }
  end

  def validate_metadata
    @validate_metadata = true
    valid?
  end

  private

  def assign_common_core_standards(value)
    names = split_list(value)
    name_node = Standard.where(name: names).where_values.reduce(:and)
    alt_names_node = Standard.where.overlap(alt_names: names).where_values.reduce(:and)
    self.common_core_standards = CommonCoreStandard.where(name_node.or(alt_names_node))
  end

  def assign_grades(value)
    grades = split_list(value)
    grades.map! do |grade|
      case grade
      when 'k' then 'kindergarten'
      when 'pk' then 'prekindergarten'
      else "grade #{grade}"
      end
    end
    self.grade_list = grades
  end

  def assign_subject(value)
    subject = value.strip.downcase
    self.subject = subject if %w(ela math).include?(subject)
  end

  def assign_unbounded_standards(value)
    names = split_list(value)

    unbounded_standards.where.not(name: names).each do |standard|
      content_guide_standards.find_by_standard_id(standard.id).delete
    end

    names.each do |name|
      standard = UnboundedStandard.create_with(subject: '').find_or_create_by(name: name)
      unbounded_standards << standard if standard && !unbounded_standards.include?(standard)
    end
  end

  def downcase(str)
    str.mb_chars.downcase.to_s rescue nil
  end

  def downcase_permalink
    self.permalink = downcase(permalink)
    true
  end

  def download_images(doc)
    doc.css('img').each do |img|
      url = img[:src]
      if (image = ContentGuideImage.find_or_create_by_original_url(value))
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

  def set_slug
    value = update_metadata ? slug : title
    return true unless value.present?

    value = downcase(value)
    self.slug = value.gsub(/(_|[[:space:]])/, '-').gsub(/[^-[[:alnum:]]]/, '').gsub(/-+/, '-')
  end

  def icon_values
    errors.add(:base, :invalid) if paragraphs_with_invalid_icons.any?
  end

  def media_exist
    if non_existent_podcasts.any? || non_existent_videos.any?
      errors.add(:base, :invalid)
    end
  end

  def no_broken_ext_links
    errors.add(:base, :invalid) if broken_ext_links.any?
  end

  def presenter
    @presenter ||= ContentGuidePresenter.new(self)
  end

  def process_list_styles(doc)
    doc.xpath('//style').each do |stylesheet|
      stylesheet.text.scan(/\.lst-(\S+)[^\{\}]+>\s*(?:li:before)\s*{\s*content[^\{\}]+counter\(lst-ctn-\1\,([^\)]+)\)/) do |match|

        list_selector, counter_type = "ol.lst-#{match[0]}", match[1]
        doc.css(list_selector).each do |element|

          element['style'] = [element['style'], "list-style-type: #{counter_type}"].join(';')

        end
      end
    end
    doc
  end

  def process_content
    doc = Nokogiri::HTML(original_content)
    doc = process_list_styles(doc)
    body = doc.xpath('/html/body/*').to_s
    body = Nokogiri::HTML.fragment(body)
    body = download_images(body)
    body = extract_links(body)
    body = process_metadata(body)
    self.content = body.to_s
  end

  def process_metadata(doc)
    table = doc.at_css('table')
    return doc unless table

    table.search('br').each { |br| br.replace("\n") }
    table.css('tr').each do |tr|
      key, value = tr.css('td').map(&:content).map(&:strip)
      case key
      when 'ccss' then assign_common_core_standards(value)
      when 'related_instruction_tags' then assign_unbounded_standards(value)
      when 'big_photo', 'small_photo' then send("remote_#{key}_url=", value)
      when 'grade', 'grades' then assign_grades(value)
      when 'subject' then assign_subject(value)
      else send("#{key}=", value) # TODO: what if key is blank?
      end
    end

    table.remove
    doc
  end

  def split_list(value)
    value.split(',').map(&:strip).map(&:downcase)
  end

  def tasks_have_break
    errors.add(:base, :invalid) if tasks_without_break.any?
  end

  def validate_metadata?
    !!@validate_metadata
  end
end
