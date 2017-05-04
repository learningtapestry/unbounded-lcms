class LessonDocument < ActiveRecord::Base
  belongs_to :resource

  before_save :set_resource_from_metadata

  store_accessor :metadata

  private

    def set_resource_from_metadata
      if context = curriculum_context
        curriculum = Curriculum.find_by_context(context)
        self.resource_id = curriculum ? curriculum.item_id : nil
      end
    end

    def curriculum_context
      context_keys = [:subject, :grade, :module, :unit, :lesson]
      return nil unless context_keys.all?{ |key| metadata[key].present? }

      {
        subject: metadata[:subject],
        grade:   (metadata[:grade] =~ /\d+/ ? "grade #{grade}" : metadata[:grade]),
        module:  metadata[:module],
        unit:    (metadata[:subject] =~ /ela/ ? "unit #{metadata[:unit]}" : "topic #{metadata[:unit]}"),
        lesson:  "lesson #{metadata[:lesson]}",
      }
    end
end
