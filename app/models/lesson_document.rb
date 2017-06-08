class LessonDocument < ActiveRecord::Base
  include Searchable
  include PDFDownloadable

  belongs_to :resource

  before_save :clean_curriculum_metadata
  before_save :set_resource_from_metadata

  store_accessor :foundational_metadata
  store_accessor :metadata
  serialize :toc, DocTemplate::Objects::TOCMetadata

  mount_uploader :pdf, LessonDocumentPdfUploader

  scope :actives,   -> { where(active: true) }
  scope :inactives, -> { where(active: false) }

  scope :where_metadata, ->(key, val) { where('metadata @> hstore(:key, :val)', key: key, val: val) }

  scope :order_by_curriculum, lambda {
    keys = %i(subject grade module unit topic lesson)
    order(keys.map { |k| "lesson_documents.metadata -> '#{k}'" }.join(', '))
  }

  scope :filter_by_term, lambda { |search_term|
    term = "%#{search_term}%"
    joins(:resource).where('resources.title ILIKE ? OR name ILIKE ?', term, term)
  }

  scope :filter_by_subject, ->(subject) { where_metadata(:subject, subject) }

  scope :filter_by_grade, ->(grade) { where_metadata(:grade, grade) }

  def file_url
    "https://docs.google.com/document/d/#{file_id}"
  end

  def ela?
    metadata['subject'].try(:downcase) == 'ela'
  end

  def math?
    metadata['subject'].try(:downcase) == 'math'
  end

  def activate!
    self.class.transaction do
      # deactive all other lessons for this resource
      self.class.where(resource_id: resource_id)
        .where.not(id: id)
        .update_all active: false
      # activate this lesson
      # obs: were we want a simple sql update statement, without rails callbacks
      update_columns active: true
    end
  end

  def title
    metadata['title']
  end

  private

  def clean_curriculum_metadata
    return unless metadata.present?

    # downcase subjects
    metadata['subject'] = metadata['subject'].try(:downcase)

    # parse to a valid GradesListHelper::GRADES value
    /(\d+)/.match(metadata['grade']) do |m|
      metadata['grade'] = "grade #{m[1]}"
    end

    # store only the lesson number
    return unless metadata['lesson'].present?
    metadata['lesson'] = metadata['lesson'].match(/lesson (\d+)/i).try(:[], 1) || metadata['lesson']
  end

  def set_resource_from_metadata
    return unless metadata.present?

    context = curriculum_context
    if metadata['type'] =~ /assessment/
      assessment = Assessment.new(context, metadata)
                     .fix_metadata!
                     .find_or_create
      self.resource_id = assessment.id
    else
      curriculum = Curriculum.find_by_context(context)
      if curriculum && curriculum.lesson?
        resource = curriculum.resource
        resource.update(**resource_update_attrs)
        self.resource_id = resource.id
      end
    end
  end

  def curriculum_context
    subject = metadata['subject']
    grade = metadata['grade']
    mod = ela? ? metadata['module'] : metadata['unit']
    mod = "module #{mod}" unless mod.include?('strand')
    unit = ela? ? "unit #{metadata['unit']}" : "topic #{metadata['topic']}"
    lesson = "lesson #{metadata['lesson']}"

    { subject: subject, grade: grade, module: mod, unit: unit, lesson: lesson }
  end

  def resource_update_attrs
    update_attrs = {}
    update_attrs[:title] = metadata['title'] if metadata['title'].present?
    update_attrs[:teaser] = metadata['teaser'] if metadata['teaser'].present?
    update_attrs[:description] = metadata['description'] if metadata['description'].present?
    update_attrs
  end
end
