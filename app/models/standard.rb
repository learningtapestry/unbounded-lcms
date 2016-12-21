class Standard < ActiveRecord::Base
  include CCSSStandardFilter
  mount_uploader :language_progression_file, LanguageProgressionFileUploader

  has_many :content_guide_standards, dependent: :destroy
  has_many :content_guides, through: :content_guide_standards

  has_many :resource_standards
  has_many :resources, through: :resource_standards

  has_many :standard_emphases, class_name: 'StandardEmphasis', dependent: :destroy

  scope :by_grade, ->(grade) {
    self.by_grades([grade])
  }

  scope :by_grades, ->(grades) {
    joins(resource_standards: { resource: [:grades] }).where(
      'grades.id' => grades.map(&:id)
    )
  }

  scope :by_collection, ->(collection) {
    self.by_collection([collection])
  }

  scope :by_collections, ->(collections) {
    joins(resource_standards: { resource: [:resource_children] }).where(
      'resource_children.resource_collection_id' => collections.map(&:id)
    )
  }

  scope :ela, ->{ where(subject: 'ela') }
  scope :math, ->{ where(subject: 'math') }

  scope :bilingual, ->{ where(is_language_progression_standard: true) }

  scope :search_by_name, ->(std) do
    find_by_sql(
      <<-SQL
        SELECT DISTINCT ON (id) *
        FROM (
          SELECT *, unnest(alt_names) alt_name FROM standards
        ) x
        WHERE alt_name ILIKE '%#{std}%' OR name ILIKE '%#{std}%'
        ORDER BY id ASC;
      SQL
    )
  end

  def attachment_url
    language_progression_file.url if language_progression_file.present?
  end

  def short_name
    alt_names.map { |n| filter_ccss_standards(n) }.compact.try(:first) || name
  end

  def emphasis(grade=nil)
    # if we have a grade, grab first the emphasis for the corresponding grade,
    # if it doesnt exists then grab the general emphasis (with grade=nil)
    if grade.present?
      standard_emphases.where(grade: [grade, nil]).order(:grade).first.try(:emphasis)

    else
      standard_emphases.first.try(:emphasis)
    end
  end
end
