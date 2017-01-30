module Oneoff
  class Issue502
    attr_reader :csv_filepath
    def initialize
      @csv_filepath = ENV.fetch('CSV_PATH')
    end

    def run
      puts "resource_id,breadcrumbs,resource_title,action"
      CSV.foreach(csv_filepath, headers: true) do |row|
        context = build_context(row)
        next if context.nil?

        ResourceHandler.new(context).run
      end
    end

    def build_context(row)
      title = row['Title']
      return nil if title.nil?

      ctx = {
        row:    row,
        grade:  title.match(/Grade (\d+) ELA/)[1],
        unit:   title.match(/, Unit (\w+)/).try(:[], 1),
        lesson: title.match(/, Part (\w+)$/).try(:[], 1)
      }

      ctx[:curriculum] = find_curriculum(ctx)
      ctx[:resource] = ctx[:curriculum].resource

      ctx[:level] = if ctx[:unit].nil? && ctx[:lesson].nil?
                      :module
                    elsif ctx[:unit].present? && ctx[:lesson].nil?
                      :unit
                    elsif ctx[:lesson].present?
                      :lesson
                    end

      ctx
    end

    def find_curriculum(ctx)
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

    private

      class ResourceHandler
        attr_reader :context

        def initialize(context)
          @context = context
        end

        def run
          case context[:level]
          when :module then module_level_tasks
          when :unit   then unit_level_tasks
          when :lesson then lesson_level_tasks
          end
        end

        def resource
          context[:resource]
        end

        def module_level_tasks
          # DO NOTHING
        end

        def unit_level_tasks
          remove_all_downloads
          update_description
        end

        def lesson_level_tasks
          update_description
        end

        def remove_all_downloads
          # ResourceDownload.where(resource_id: resource.id).delete_all if resource
          if resource.downloads.count > 0
            puts "#{resource.id},#{context[:curriculum].breadcrumb_title},resource.title,remove downloads"
          end
        end

        def update_description
          description = context[:row]['Description']
          # resource.description = context[:row]['Description']
          # resource.save
          if description.present?
            puts "#{resource.id},#{context[:curriculum].breadcrumb_title},resource.title,update description"
          end
        end
      end
  end
end
