class Resource < ActiveRecord::Base
  extend OrderAsSpecified
  include Searchable
  include CCSSStandardFilter
  include GradeListHelper
  include VideoEmbed

  DOWNLOAD_PER_CATEGORY_LIMIT = 5

  mount_uploader :image_file, ResourceImageUploader

  enum resource_type: {
    resource: 1,
    podcast: 2,
    video: 3,
    quick_reference_guide: 4,
    text_set: 5
  }

  acts_as_taggable_on :content_sources,
    :download_types,
    :grades,
    :resource_types,
    :tags,
    :topics

  # Additional resources
  has_many :resource_additional_resources, dependent: :destroy
  has_many :additional_resources, through: :resource_additional_resources

  # Standards.
  has_many :resource_standards, dependent: :destroy
  has_many :standards, through: :resource_standards
  has_many :common_core_standards, ->{ where(type: 'CommonCoreStandard') }, source: :standard, through: :resource_standards
  has_many :unbounded_standards, ->{ where(type: 'UnboundedStandard') }, source: :standard, through: :resource_standards

  # Downloads.
  has_many :resource_downloads, dependent: :destroy
  has_many :downloads, through: :resource_downloads

  # Curriculums.
  has_many :curriculums, as: :item, dependent: :destroy

  # Reading assignments.
  has_many :resource_reading_assignments, dependent: :destroy
  alias_attribute :reading_assignments, :resource_reading_assignments
  has_many :reading_assignment_texts, through: :resource_reading_assignments

  # Related resources.
  has_many :resource_related_resources, dependent: :destroy
  has_many :related_resources, through: :resource_related_resources, class_name: 'Resource'
  has_many :resource_related_resources_as_related,
    class_name: 'ResourceRelatedResource',
    foreign_key: 'related_resource_id',
    dependent: :destroy

  # Requirements
  has_many :resource_requirements, dependent: :destroy
  has_many :requirements, through: :resource_requirements

  # Slugs
  has_many :resource_slugs, dependent: :destroy
  alias_attribute :slugs, :resource_slugs

  has_many :content_guides, through: :unbounded_standards

  has_many :copyright_attributions

  has_many :social_thumbnails, as: :target

  validates :title, presence: true
  validates :url, presence: true, url: true, if: [:video?, :podcast?]

  accepts_nested_attributes_for :resource_downloads, allow_destroy: true

  scope :lessons, -> {
    joins(:curriculums)
    .where(curriculums: { curriculum_type: CurriculumType.lesson })
    .where.not(curriculums: { seed_id: nil })
  }

  scope :where_subject, ->(subjects) {
    subjects = Array.wrap(subjects)
    return where(nil) unless subjects.any?

    where(subject: subjects)
  }

  scope :where_tag, ->(context, value) {
    value = Array.wrap(value)
    return where(nil) unless value.any?

    joins(taggings: [:tag])
    .where(taggings: { context: context })
    .where(tags: { name: value })
  }

  scope :where_grade, ->(grades) {
    where_tag('grades', grades)
  }

  scope :asc, -> { order(created_at: :asc) }
  scope :desc, -> { order(created_at: :desc) }

  scope :videos, -> { where(resource_type: self.resource_types[:video]) }
  scope :podcasts, -> { where(resource_type: self.resource_types[:podcast]) }
  scope :media, -> { where(resource_type: [self.resource_types[:video], self.resource_types[:podcast]])}

  scope :generic_resources, -> do
    where(resource_type: [
      self.resource_types[:text_set],
      self.resource_types[:quick_reference_guide]
    ])
  end

  class << self
    def by_title(title)
      where(title: title)
    end

    def bulk_edit(sample, resources)
      before = init_for_bulk_edit(resources)
      after  = sample

      transaction do
        resources.each do |resource|
          # Standards
          resource.resource_standards.where(standard_id: before.standard_ids).where.not(standard_id: after.standard_ids).destroy_all
          (after.standard_ids - before.standard_ids).each do |standard_id|
            resource.resource_standards.find_or_create_by!(standard_id: standard_id)
          end

          resource.grades_list = sample.grades_list
          resource.tags_list = sample.tags_list
          resource.resource_types_list = sample.resource_types_list

          resource.save!
          resource
        end
      end
    end

    def find_podcast_by_url(url)
      podcast.where(url: url).first
    end

    def find_video_by_url(url)
      video_id = video_id(url)
      video.where("url ~ '#{video_id}(&|$)'").first
    end

    def init_for_bulk_edit(resources)
      resource = new
      resource.standard_ids = resources.map(&:standard_ids).inject { |memo, ids| memo &= ids }
      resource
    end

    def sort_by_type_and_grade
      type_grade_score = lambda do |r|
        indices =
          r.taggings.map do |t|
            grade = t.tag.name if t.context == 'grades'
            GradeListHelper::GRADES.index(grade)
          end.compact
        [r.resource_type, indices.min || 0, indices.size]
      end
      includes(taggings: :tag).sort_by(&type_grade_score)
    end

    def sort_by_subject_and_grade
      subject_grade_score = lambda do |r|
        [r.subject, r.grade_avg_num, r.title]
      end
      includes(taggings: :tag).sort_by(&subject_grade_score)
    end
  end

  def text_description
    # doc = Nokogiri::HTML(description)
    # doc.xpath('//p/text()').text
    Nokogiri::HTML(description).text
  rescue
    nil
  end

  def related_resources
    @related_resources ||= resource_related_resources
      .includes(:related_resource)
      .order(:position)
      .map(&:related_resource)
  end

  def downloads_by_category
    by_category = {}
    resource_downloads.group_by { |d| d.download_category.try(:name) }.each do |key, dl_group|
      by_category[key] = dl_group.map(&:download)
      yield key, by_category[key] if block_given?
    end
    by_category
  end

  def download_categories
    resource_downloads
      .group_by { |d| d.download_category.try(:category_name) || '' }
      .sort_by { |k, _| k }.to_h
      .transform_values { |v| v.sort_by { |d| [d.download.main ? 0 : 1, d.download.title] } }
  end

  def pdf_downloads?
    downloads.any? { |d| d.attachment_content_type == 'pdf' }
  end

  def prerequisites_standards
    ids = StandardLink.where(standard_end_id: common_core_standards.pluck(:id))
                      .where.not(link_type: 'c')
                      .pluck(:standard_begin_id)
    Standard.where(id: ids).pluck(:alt_names).flatten.uniq
            .map { |n| filter_ccss_standards(n) }.compact.sort
  end

  def bilingual_standards
    standards.bilingual.distinct.order(:name)
  end

  def first_tree
    curriculums.trees.first
  end

  def curriculums_as_parent
    curriculums.seeds.where(parent_id: nil)
  end

  def ela?
    subject == 'ela'
  end

  def math?
    subject == 'math'
  end

  def generate_content_sources
    unless self.content_source_list.any?
      content_source = engageny_url.present? ? 'engageny' : 'unbounded'
      self.content_source_list.add(content_source)
    end
    self.content_source_list
  end

  # Tags

  def update_download_types
    self.download_type_list = resource_downloads.map do |resource_download|
      download = resource_download.download
      case download.content_type
      when 'application/zip'
        'zip'
      when 'application/pdf'
        'pdf'
      when 'application/vnd.ms-excel',
           'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        'excel'
      when 'application/vnd.ms-powerpoint',
           'application/vnd.openxmlformats-officedocument.presentationml.presentation'
        'powerpoint'
      when 'application/msword',
           'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        'doc'
      end
    end.uniq.compact
  end

  def media?
    ['video', 'podcast'].include? resource_type
  end

  def generic?
    ['text_set', 'quick_reference_guide'].include?(resource_type)
  end

  alias :do_not_skip_indexing? :should_index?
  def should_index?
    # index only videos and podcast (other resources are indexed via Curriculum)
    do_not_skip_indexing? && (media? || generic?)
  end

  def named_tags
    {
      keywords: (tag_list + topic_list).compact.uniq,
      resource_type: resource_type,
      ell_appropriate: ell_appropriate,
      ccss_standards: tag_standards,
      ccss_domain: nil,  # resource.standards.map { |std| std.domain.try(:name) }.uniq
      ccss_cluster: nil,  #  resource.standards.map { |std| std.cluster.try(:name) }.uniq
      authors: reading_assignment_texts.map {|t| t.author.try(:name) }.compact.uniq,
      texts: reading_assignment_texts.map(&:name).uniq,
    }
  end

  def filtered_named_tags
    filtered_named_tags = named_tags
    filtered_named_tags.merge(
      ccss_standards: named_tags[:ccss_standards]
                        .map { |n| filter_ccss_standards(n) }
                        .compact
    )
  end

  def tag_standards
    common_core_standards.map(&:alt_names).flatten.uniq
  end

  def copyrights
    copyright_attributions
  end
end
