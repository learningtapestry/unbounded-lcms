class Resource < ActiveRecord::Base

  # Additonal resources
  has_many :resource_additional_resources, dependent: :destroy
  has_many :additional_resources, through: :resource_additional_resources

  # Subjects.
  has_many :resource_subjects, dependent: :destroy
  has_many :subjects, through: :resource_subjects

  # Topics.
  has_many :resource_topics, dependent: :destroy
  has_many :topics, through: :resource_topics

  # Alignments.
  has_many :resource_alignments, dependent: :destroy
  has_many :alignments, through: :resource_alignments

  # Resource types.
  has_many :resource_resource_types, dependent: :destroy
  has_many :resource_types, through: :resource_resource_types

  # Downloads.
  has_many :resource_downloads, dependent: :destroy
  has_many :downloads, through: :resource_downloads

  # Grades.
  has_many :resource_grades, dependent: :destroy
  has_many :grades, through: :resource_grades

  # Curriculums.
  has_many :curriculums, as: :item

  # Related resources.
  has_many :resource_related_resources, dependent: :destroy
  has_many :related_resources, through: :resource_related_resources

  # Requirements
  has_many :resource_requirements, dependent: :destroy
  has_many :requirements, through: :resource_requirements

  accepts_nested_attributes_for :resource_downloads, allow_destroy: true

  scope :lessons, -> {
    joins(:curriculums)
    .where(curriculums: { curriculum_type: CurriculumType.lesson })
    .where.not(curriculums: { seed_id: nil })
  }

  scope :where_subject, ->(subjects) {
    subjects = Array.wrap(subjects)
    return where(nil) unless subjects.any?

    joins(:subjects)
    .where(
      'subjects.id' => Array.wrap(subjects).map(&:id)
    )
  }

  scope :where_grade, ->(grades) {
    grades = Array.wrap(grades)
    return where(nil) unless grades.any?

    joins(:grades)
    .where(
      'grades.id' => Array.wrap(grades).map(&:id)
    )
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
          # Alignments
          resource.resource_alignments.where(alignment_id: before.alignment_ids).where.not(alignment_id: after.alignment_ids).destroy_all
          (after.alignment_ids - before.alignment_ids).each do |alignment_id|
            resource.resource_alignments.find_or_create_by!(alignment_id: alignment_id)
          end

          # Grades
          resource.resource_grades.where(grade_id: before.grade_ids).where.not(grade_id: after.grade_ids).destroy_all
          (after.grade_ids - before.grade_ids).each do |grade_id|
            resource.resource_grades.find_or_create_by!(grade_id: grade_id)
          end

          # Resource types
          resource.resource_resource_types.where(resource_type_id: before.resource_type_ids).where.not(resource_type_id: after.resource_type_ids).destroy_all
          (after.resource_type_ids - before.resource_type_ids).each do |resource_type_id|
            resource.resource_resource_types.find_or_create_by!(resource_type_id: resource_type_id)
          end

          # Subjects
          resource.resource_subjects.where(subject_id: before.subject_ids).where.not(subject_id: after.subject_ids).destroy_all
          (after.subject_ids - before.subject_ids).each do |subject_id|
            resource.resource_subjects.find_or_create_by!(subject_id: subject_id)
          end
        end
      end
    end

    def init_for_bulk_edit(resources)
      resource = new
      resource.alignment_ids     = resources.map(&:alignment_ids).inject { |memo, ids| memo &= ids }
      resource.grade_ids         = resources.map(&:grade_ids).inject { |memo, ids| memo &= ids }
      resource.resource_type_ids = resources.map(&:resource_type_ids).inject { |memo, ids| memo &= ids }
      resource.subject_ids       = resources.map(&:subject_ids).inject { |memo, ids| memo &= ids }
      resource
    end
  end

  def text_description
    doc = Nokogiri::HTML(description)
    doc.xpath('//p/text()').text
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
end
