class Standard < ActiveRecord::Base
  ALT_NAME_REGEX = {
    'ela' => /^[[:alpha:]]+\.(k|pk|\d+)\.\d+(\.[[:alnum:]]+)?$/,
    'math' => /^(k|pk|\d+)\.[[:alpha:]]+(\.[[:alpha:]]+)?\.\d+(\.[[:alpha:]]+)?$/
  }.freeze

  validates_presence_of :subject

  mount_uploader :language_progression_file, LanguageProgressionFileUploader

  has_many :content_guide_standards, dependent: :destroy
  has_many :content_guides, through: :content_guide_standards

  has_many :resource_standards
  has_many :resources, through: :resource_standards

  has_many :standard_emphases, class_name: 'StandardEmphasis', dependent: :destroy

  scope :bilingual, -> { where(is_language_progression_standard: true) }

  scope :by_grade, ->(grade) { by_grades [grade] }
  scope :by_grades, lambda { |grades|
    joins(resource_standards: { resource: [:grades] })
      .where('grades.id' => grades.map(&:id))
  }

  scope :ela, -> { where(subject: 'ela') }
  scope :math, -> { where(subject: 'math') }

  def self.search_by_name(name)
    # TODO: Need to check, possible SQL injection hole
    find_by_sql(
      <<-SQL
        SELECT DISTINCT ON (id) *
        FROM (
          SELECT *, unnest(alt_names) alt_name FROM standards
        ) x
        WHERE (alt_name ILIKE '%#{name}%' OR name ILIKE '%#{name}%')
        ORDER BY id ASC;
      SQL
    )
  end

  def self.filter_ccss_standards(name)
    name.upcase if name =~ (ALT_NAME_REGEX[subject] || /.*/)
  end

  def attachment_url
    language_progression_file.url if language_progression_file.present?
  end

  def short_name
    alt_names.map { |n| self.class.filter_ccss_standards(n) }.compact.try(:first) || name
  end

  def emphasis(grade = nil)
    # if we have a grade, grab first the emphasis for the corresponding grade,
    # if it doesn't exists then grab the general emphasis (with grade = nil)
    if grade.present?
      standard_emphases.where(grade: [grade, nil]).order(:grade).first.try(:emphasis)
    else
      standard_emphases.first.try(:emphasis)
    end
  end
end
