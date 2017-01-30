module Oneoff
  class Issue502
    attr_reader :csv_filepath
    def initialize
      @csv_filepath = ENV.fetch('CSV_PATH')
    end

    def run
      CSV.foreach(csv_filepath, headers: true) do |row|
        context = build_context(row)
        next if context.nil?

        curriculum = find(context)
        puts curriculum.curriculum_type.name, curriculum.resource.title
      end
    end

    def find(ctx)
      # Grade
      curr = Curriculum.trees.ela.with_resources.where_grade("grade #{ctx[:grade]}").first

      # Module
      mod = curr.children.select { |c| c.resource.short_title == 'core proficiencies' }.first
      curr = mod if mod

      # Unit
      if ctx[:unit]
        unit = curr.children.select { |c| c.resource.short_title == "unit #{ctx[:unit].downcase}" }.first
        curr = unit if unit
      end

      # Lesson
      if ctx[:lesson]
        lesson = curr.children.select { |c| c.resource.short_title == "part #{ctx[:lesson].downcase}" }.first
        curr = lesson if lesson
      end

      curr
    end

    def build_context(row)
      title = row['Hierarchy Title']
      return nil if title.nil?

      ctx = {}
      ctx[:grade]  = title.match(/Grade (\d+) ELA/)[1]
      ctx[:unit]   = title.match(/, Unit (\w+)/).try(:[], 1)
      ctx[:lesson] = title.match(/, Part (\w+)$/).try(:[], 1)

      ctx
    end

    def module_level_tasks
    end

    def unit_level_tasks
    end

    def lesson_level_task
    end
  end
end
