class CurriculumTasks
  class << self
    def generate_breadcrumbs
      Curriculum.trees.find_each { |c| c.generate_breadcrumb_pieces ; c.save! }
      Curriculum.trees.find_each { |c| c.generate_breadcrumb_titles ; c.save! }
    end

    def sync_reading_assignments
      Curriculum.transaction do
        [:units, :modules, :grades].each do |level|
          Curriculum.trees.send(level).find_each do |node|
            res = node.resource
            res.reading_assignments.destroy_all
            Curriculum.where(parent_id: node.id)
              .joins(resource_item: [:resource_reading_assignments])
              .select(:reading_assignment_text_id)
              .distinct(:reading_assignment_text_id)
              .pluck(:reading_assignment_text_id)
              .each do |text_id|
                ResourceReadingAssignment.create(
                  resource_id: res.id,
                  reading_assignment_text_id: text_id
                )
              end
          end
        end
      end
    end
  end
end
