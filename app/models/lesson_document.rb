require 'doc_template/objects/toc_metadata'

class LessonDocument < ActiveRecord::Base
  belongs_to :resource

  before_save :set_resource_from_metadata

  store_accessor :metadata
  serialize :toc, DocTemplate::TOCMetadata

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

  scope :filter_by_grade, ->(grade) do
    grade_value = grade.match(/grade (\d+)/).try(:[], 1) || grade
    where_metadata(:grade, grade_value)
  end

  def file_url
    "https://docs.google.com/document/d/#{file_id}"
  end

  private

    def set_resource_from_metadata
      if metadata.present?
        metadata['subject'] = metadata['subject'].try(:downcase)

        context = curriculum_context
        curriculum = Curriculum.find_by_context(context)
        self.resource_id = curriculum && curriculum.lesson? ? curriculum.item_id : nil
      end
    end

    def curriculum_context
      subject = metadata['subject']
      grade = metadata['grade'] =~ /\d+/ ? "grade #{metadata['grade']}" : metadata['grade']
      mod = ela? ? metadata['module'] : metadata['unit']
      mod = "module #{mod}" unless mod.include?('strand')
      unit = ela? ? "unit #{metadata['unit']}" : "topic #{metadata['topic']}"
      lesson = "lesson #{metadata['lesson']}"

      {subject: subject, grade: grade, module: mod, unit: unit, lesson: lesson}
    end

    def ela?
      metadata['subject'].try(:downcase) == 'ela'
    end

    def math?
      metadata['subject'].try(:downcase) == 'math'
    end
end
