class LessonDocument < ActiveRecord::Base
  belongs_to :resource

  before_save :set_resource_from_metadata

  store_accessor :metadata
  serialize :toc, DocTemplate::TOCMetadata

  private

    def set_resource_from_metadata
      if metadata.present? && context = curriculum_context
        curriculum = Curriculum.find_by_context(context)
        self.resource_id = curriculum && curriculum.lesson? ? curriculum.item_id : nil
      end
    end

    def curriculum_context
      subject = metadata['subject'].try(:downcase)
      grade = metadata['grade'] =~ /\d+/ ? "grade #{metadata['grade']}" : metadata['grade']
      mod = ela? ? metadata['module'] : metadata['unit']
      mod = "module #{mod}" if mod =~ /^\d+$/
      unit = ela? ? "unit #{metadata['unit']}" : "topic #{metadata['topic']}"
      lesson = "lesson #{metadata['lesson']}"

      {subject: subject, grade: grade, module: mod, unit: unit, lesson: lesson}
    end

    def ela?
      metadata['subject'] =~ /ela/
    end

    def math?
      metadata['subject'] =~ /math/
    end
end
