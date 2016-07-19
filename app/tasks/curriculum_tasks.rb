class CurriculumTasks
  class << self
    def generate_breadcrumbs
      generate_resources_short_titles
      Curriculum.trees.find_each { |c| c.generate_breadcrumb_pieces ; c.save! }
      Curriculum.trees.find_each { |c| c.generate_breadcrumb_titles ; c.save! }
    end

    def generate_hierarchical_positions
      Curriculum.trees.find_each { |c| c.generate_hierarchical_position ; c.save! }
    end

    def generate_resources_short_titles
      Curriculum.trees.with_resources.lessons.find_each { |c| c.create_resource_short_title! }
    end

    def reset_slugs
      ResourceSlug.destroy_all
      Curriculum.trees.with_resources.find_each { |c| ResourceSlug.create_for_curriculum(c) rescue nil }
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

    def update_time_to_teach
      ActiveRecord::Base.transaction do
        Curriculum.lessons.with_resources.find_each do |cur|
          res = cur.resource
          next if res.time_to_teach.present? && res.time_to_teach != 0
          cur.resource.update_attributes(time_to_teach: 60)
        end

        Curriculum.units.with_resources.find_each do |cur|
          total = cur.children.map { |c| c.resource.time_to_teach }.sum
          cur.resource.update_attributes(time_to_teach: total)
        end

        Curriculum.modules.with_resources.find_each do |cur|
          total = cur.children.map { |c| c.resource.time_to_teach }.sum
          cur.resource.update_attributes(time_to_teach: total)
        end

        Curriculum.grades.with_resources.find_each do |cur|
          total = cur.children.map { |c| c.resource.time_to_teach }.sum
          cur.resource.update_attributes(time_to_teach: total)
        end

        Curriculum.maps.seeds.find_each do |cur|
          total = cur.children.map { |c| c.resource.time_to_teach }.sum
          cur.resource.update_attributes(time_to_teach: total)
        end
      end
    end
  end
end
