module Oneoff
  class Issue502
    attr_reader :csv_filepath
    def initialize
      @csv_filepath = ENV.fetch('CSV_PATH')
    end

    def run
      # puts 'resource_id,breadcrumbs,resource_title,action'
      CSV.foreach(csv_filepath, headers: true) do |row|
        context = build_context(row)
        next if context.nil?

        ResourceHandler.new(context).run
        print '.'
      end
      puts '\n'
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

      ctx[:level] = if ctx[:unit].blank? && ctx[:lesson].blank?
                      :module
                    elsif ctx[:unit].present? && ctx[:lesson].blank?
                      :unit
                    elsif ctx[:lesson].present?
                      :lesson
                    end

      ctx
    end

    def find_curriculum(ctx)
      # Grade
      curr = Curriculum.trees
                       .grades
                       .where_subject('ela')
                       .where_grade("grade #{ctx[:grade]}")
                       .first

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
        attr_reader :context, :files_path

        def initialize(context)
          @context = context
          @files_path = File.join(ENV.fetch('FILES_PATH'), "grade #{context[:grade]}", "unit #{context[:unit]}")
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
          create_zip_with_all_files
          unit_level_downloads
        end

        def lesson_level_tasks
          update_description
          lesson_level_downloads
          add_to_each_lesson_downloads
        end

        def remove_all_downloads
          if resource.downloads.count > 0
            ResourceDownload.where(resource_id: resource.id).delete_all if resource
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "remove downloads"
          end
        end

        def update_description
          description = context[:row]['Description']
          if description.present?
            resource.description = description.gsub(/\n/, '<br />')
            resource.save
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "update description"
          end
        end

        def create_zip_with_all_files
          zip_name = "ELA #{context[:grade]} Developing Core Proficiencies Unit #{context[:unit]} - All files"
          FileUtils.cd(files_path) do
            # create file to contain zipped files
            FileUtils.mkdir_p zip_name

            # copy relevant files to be zipped
            FileUtils.cp_r(
              Dir[
                '*.pdf',                                     # All lesson files
                File.join('Unit Level Downloads', '*.pdf'),  # Unit level downloads, without the folder
                File.join('add to each lesson (part)', '*')  # All folders inside 'add to each lesson (part)'
              ],
              zip_name
            )

            # zip whole folder
            `zip -r "#{zip_name}.zip" "#{zip_name}"`

            # remove tmp folder
            FileUtils.rm_r zip_name
          end
          File.open(File.join(files_path, zip_name + '.zip')) do |zipfile|
            download = Download.create(file: zipfile, title: zip_name)
            resource.downloads << download
            resource.save

            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{zip_name}.zip"
          end
        end

        def unit_level_downloads
          Dir[File.join(files_path, 'Unit Level Downloads', '*.pdf')].each do |path|
            path = Pathname.new(path)
            fname = path.basename.to_s.gsub('.pdf', '')

            download = Download.create(file: File.open(path), title: fname)
            resource.downloads << download
            resource.save

            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{fname}"
          end
        end

        def lesson_level_downloads
          Dir[File.join(files_path, '*.pdf')].select do |path|
            path =~ /Part #{context[:lesson]}/

          end.each do |path|
            path = Pathname.new(path)
            fname = path.basename.to_s.gsub('.pdf', '')

            download = Download.create(file: File.open(path), title: fname)
            resource.downloads << download
            resource.save

            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{fname}"
          end
        end

        def add_to_each_lesson_downloads
          Dir[File.join(files_path, 'add to each lesson (part)', '**', '*.pdf')].each do |path|
            path = Pathname.new(path)
            fname = path.basename.to_s.gsub('.pdf', '')
            category = find_download_category(path)

            download = Download.create(file: File.open(path), title: fname)
            resource.downloads << download
            resource.save
            dr = ResourceDownload.find_by(download_id: download.id)
            dr.update_attributes download_category_id: category.id

            csv resource.id, context[:curriculum].breadcrumb_title, resource.title ,"attach (with category '#{category.description}'): #{fname}"
          end
        end

        def find_download_category(path)
          dirname = path.dirname.split.last.to_s
          category = dirname.parameterize.underscore

          DownloadCategory.find_or_create_by(name: category) do |dc|
            dc.description = dirname
          end
        end

        def csv(*attrs)
          # puts attrs.map { |attr| "\"#{attr}\"" }.join(',')
        end
      end
  end
end
