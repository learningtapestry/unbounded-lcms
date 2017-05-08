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

  def file_url
    "https://docs.google.com/document/d/#{file_id}"
  end

  private

    def set_resource_from_metadata
      metadata['subject'] = metadata['subject'].try(:downcase)

      if metadata.present? && context = curriculum_context
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
