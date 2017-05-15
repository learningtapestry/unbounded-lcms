class LessonDocument < ActiveRecord::Base
  belongs_to :resource

  before_save :clean_curriculum_metadata
  before_save :set_resource_from_metadata

  store_accessor :metadata
  serialize :toc, DocTemplate::Objects::TOCMetadata

  scope :actives,   ->{ where(active: true) }
  scope :inactives, ->{ where(active: false) }

  scope :where_metadata, ->(key, val) { where('metadata @> hstore(:key, :val)', key: key, val: val) }

  scope :order_by_curriculum, -> do
    keys = [:subject, :grade, :module, :unit, :topic, :lesson]
    order(keys.map{ |k| "lesson_documents.metadata -> '#{k}'" }.join(', '))
  end

  scope :filter_by_term, ->(search_term) do
    term = "%#{search_term}%"
    joins(:resource).where('resources.title ILIKE ? OR name ILIKE ?', term, term)
  end

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
                .where.not(id: self.id)
                .update_all active: false
      # activate this lesson
      # obs: were we want a simple sql update statement, without rails callbacks
      update_columns active: true
    end
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
    if metadata['lesson'].present?
      metadata['lesson'] = metadata['lesson'].match(/lesson (\d+)/i).try(:[], 1) || metadata['lesson']
    end
  end

  def set_resource_from_metadata
    return unless metadata.present?

    context = curriculum_context
    curriculum = Curriculum.find_by_context(context)
    self.resource_id = curriculum && (curriculum.lesson? ? curriculum.item_id : nil)
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
end
