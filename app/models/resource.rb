class Resource < ActiveRecord::Base
  include Search::ResourcesSearch

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

  # Downloads.
  has_many :resource_downloads, dependent: :destroy
  has_many :downloads, through: :resource_downloads

  # Curriculums.
  has_many :curriculums, as: :item

  # Reading assignments.
  has_many :resource_reading_assignments, dependent: :destroy
  alias_attribute :reading_assignments, :resource_reading_assignments

  # Related resources.
  has_many :resource_related_resources, dependent: :destroy
  has_many :related_resources, through: :resource_related_resources

  # Requirements
  has_many :resource_requirements, dependent: :destroy
  has_many :requirements, through: :resource_requirements

  # Slugs
  has_many :resource_slugs, dependent: :destroy
  alias_attribute :slugs, :resource_slugs

  validates :title, presence: true

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

  scope :where_grade, ->(grades) {
    grades = Array.wrap(grades)
    return where(nil) unless grades.any?

    joins(taggings: [:tag])
    .where(taggings: { context: 'grades' })
    .where(tags: { name: grades })
  }

  scope :asc, -> { order(created_at: :asc) }
  scope :desc, -> { order(created_at: :desc) }

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

    def init_for_bulk_edit(resources)
      resource = new
      resource.standard_ids = resources.map(&:standard_ids).inject { |memo, ids| memo &= ids }
      resource
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

  def first_tree
    curriculums.trees.first
  end

  def ela?
    subject == 'ela'
  end

  def math?
    subject == 'math'
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

end
