module Content
  class Document < ActiveRecord::Base
    
    # Age ranges.
    has_many :document_age_ranges, dependent: :destroy
    alias_attribute :age_ranges, :document_age_ranges

    # Subjects.
    has_many :document_subjects, dependent: :destroy
    has_many :subjects, through: :document_subjects

    # Topics.
    has_many :document_topics, dependent: :destroy
    has_many :topics, through: :document_topics

    # Alignments.
    has_many :document_alignments, dependent: :destroy
    has_many :alignments, through: :document_alignments

    # Identities.
    has_many :document_identities, dependent: :destroy
    has_many :identities, through: :document_identities
    
    # Urls.
    belongs_to :url

    # Languages.
    has_many :document_languages, dependent: :destroy
    has_many :languages, through: :document_languages

    # Resource types.
    has_many :document_resource_types, dependent: :destroy
    has_many :resource_types, through: :document_resource_types

    # Downloads.
    has_many :document_downloads, dependent: :destroy
    has_many :downloads, through: :document_downloads

    # Grades.
    has_many :document_grades, dependent: :destroy
    has_many :grades, through: :document_grades

    belongs_to :source_document

    scope :unmerged, -> { where(merged_at: nil) }

    def merged!
      self.touch(:merged_at)
    end

    def normalized_age_range
      min = age_ranges.order(min_age: :asc).limit(1).first.try(:min_age)

      max_of_min = age_ranges.order(min_age: :desc).limit(1).first.try(:min_age)
      max_of_max = age_ranges.where.not(max_age: nil).order(max_age: :desc).limit(1).first.try(:max_age)
      max = [max_of_min.to_i, max_of_max.to_i].max
      max = nil if max == 0 or min == max

      extended = !(age_ranges.where(extended_age: true).limit(1).first.nil?)

      return nil if min.nil?

      {
        min: min,
        max: max,
        extended: extended
      }
    end
  end
end
