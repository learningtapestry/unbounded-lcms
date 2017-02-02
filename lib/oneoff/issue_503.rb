module Oneoff
  class Issue503
    attr_reader :input_path
    def initialize
      @input_path = ENV.fetch('INPUT')
    end

    def run
      csv_file = File.join(@input_path, 'ela_ckla_all.csv')
      puts 'resource_id,breadcrumbs,resource_title,action'
      CSV.foreach(csv_file, headers: true) do |row|
        context = build_context(row)
        next if context.nil?

        ResourceHandler.new(context).run
        # print '.'
      end
    end

    def build_context(row)
      hierarchy_title = row['hierarchy_title'].gsub('Classic Tales Domain', 'Domain 6')  # fixes for prekindergarten specific domains
                                              .gsub('Important People Domain', 'Domain 7')
      ctx = {
        row:    row,
        grade:  parse_grade(row),
        module: parse_module(row),
        unit:   hierarchy_title.match(/(Unit|Domain) (\w+)/).try(:[], 2),
        lesson: hierarchy_title.match(/Lesson (\w+)/).try(:[], 1),
      }

      ctx[:curriculum] = find_curriculum(ctx)
      ctx[:resource] = ctx[:curriculum].resource

      ctx[:level] = if ctx[:module].blank?
                      :grade
                    elsif ctx[:unit].blank? && ctx[:lesson].blank?
                      :module
                    elsif ctx[:unit].present? && ctx[:lesson].blank?
                      :unit
                    elsif ctx[:lesson].present?
                      :lesson
                    end

      ctx
    end

    def parse_grade(row)
      hierarchy_title = row['hierarchy_title']
      if hierarchy_title =~ /^prekindergarten/i
        'prekindergarten'
      elsif hierarchy_title =~ /^kindergarten/i
        'kindergarten'
      else
        grade_num = hierarchy_title.match(/Grade (\d+) /)[1]
        "grade #{grade_num}"
      end
    end

    def parse_module(row)
      hierarchy_title = row['hierarchy_title']
      if hierarchy_title =~ /learning/i
        'learning strand'
      elsif hierarchy_title =~ /skills/i
        'skills strand'
      end
    end

    def find_curriculum(ctx)
      # Grade
      curr = Curriculum.trees
                       .grades
                       .where_subject('ela')
                       .where_grade(ctx[:grade])
                       .first

      # Module
      mod = curr.children.select { |c| c.resource.short_title == ctx[:module] }.first
      curr = mod if mod

      # Unit
      if ctx[:unit]
        unit = curr.children.select { |c| c.resource.short_title == "unit #{ctx[:unit].downcase}" }.first
        curr = unit if unit
      end

      # Lesson
      if ctx[:lesson]
        lesson = curr.children.select { |c| c.resource.short_title == "lesson #{ctx[:lesson].downcase}" }.first
        curr = lesson if lesson
      end

      curr
    end

    private

      class ResourceHandler
        attr_reader :context, :files_path

        def initialize(context)
          @context = context
          @files_path = File.join(ENV.fetch('INPUT'), 'files', context[:grade])
        end

        def run
          case context[:level]
          when :grade  then grade_level_tasks
          when :module then module_level_tasks
          # when :unit   then unit_level_tasks
          # when :lesson then lesson_level_tasks
          end
        end

        def resource
          context[:resource]
        end

        def grade_level_tasks
          remove_all_downloads
          grade_level_donwloads
        end

        def module_level_tasks
          remove_all_downloads
          module_level_downloads
        end

        def unit_level_tasks
          # remove_all_downloads
          # update_description
          # create_zip_with_all_files
          # unit_level_downloads
        end

        def lesson_level_tasks
          # update_description
          # lesson_level_downloads
          # add_to_each_lesson_downloads
        end

        def remove_all_downloads
          if resource.downloads.count > 0
            # ResourceDownload.where(resource_id: resource.id).delete_all if resource
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "remove downloads"
          end
        end

        def update_description
          # description = context[:row]['Description']
          # if description.present?
          #   resource.description = description.gsub(/\n/, '<br />')
          #   resource.save
          #   csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "update description"
          # end
        end

        def create_zip_with_all_files
          # zip_name = "ELA #{context[:grade]} Developing Core Proficiencies Unit #{context[:unit]} - All files"
          # FileUtils.cd(files_path) do
          #   # create file to contain zipped files
          #   FileUtils.mkdir_p zip_name

          #   # copy relevant files to be zipped
          #   FileUtils.cp_r(
          #     Dir[
          #       '*.pdf',                                     # All lesson files
          #       File.join('Unit Level Downloads', '*.pdf'),  # Unit level downloads, without the folder
          #       File.join('add to each lesson (part)', '*')  # All folders inside 'add to each lesson (part)'
          #     ],
          #     zip_name
          #   )

          #   # zip whole folder
          #   `zip -r "#{zip_name}.zip" "#{zip_name}"`

          #   # remove tmp folder
          #   FileUtils.rm_r zip_name
          # end
          # File.open(File.join(files_path, zip_name + '.zip')) do |zipfile|
          #   download = Download.create(file: zipfile, title: zip_name)
          #   resource.downloads << download
          #   resource.save

          #   csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{zip_name}.zip"
          # end
        end

        def build_path(*pieces)
          File.join(files_path, *pieces)
        end

        def all_downloads(folder)
          Dir[File.join(folder, '**', '*')].each do |path|
            if File.file?(path)
              fname = File.basename(path).gsub(/\.\w+$/, '')

              # download = Download.create(file: File.open(path), title: fname)
              # resource.downloads << download
              # resource.save
              csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{fname}"
            end
          end

        end

        def grade_level_donwloads
          all_downloads build_path('Grade Level Downloads')
        end

        def module_level_downloads
          all_downloads build_path(context[:module], 'Module Level Downloads')
        end

        def unit_level_downloads
          # Dir[File.join(files_path, 'Unit Level Downloads', '*.pdf')].each do |path|
          #   path = Pathname.new(path)
          #   fname = path.basename.to_s.gsub('.pdf', '')

          #   download = Download.create(file: File.open(path), title: fname)
          #   resource.downloads << download
          #   resource.save

          #   csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{fname}"
          # end
        end

        def lesson_level_downloads
          # Dir[File.join(files_path, '*.pdf')].select do |path|
          #   path =~ /Part #{context[:lesson]}/

          # end.each do |path|
          #   path = Pathname.new(path)
          #   fname = path.basename.to_s.gsub('.pdf', '')

          #   download = Download.create(file: File.open(path), title: fname)
          #   resource.downloads << download
          #   resource.save

          #   csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{fname}"
          # end
        end

        def add_to_each_lesson_downloads
          # Dir[File.join(files_path, 'add to each lesson (part)', '**', '*.pdf')].each do |path|
          #   path = Pathname.new(path)
          #   fname = path.basename.to_s.gsub('.pdf', '')
          #   category = find_download_category(path)

          #   download = Download.create(file: File.open(path), title: fname)
          #   resource.downloads << download
          #   resource.save
          #   dr = ResourceDownload.find_by(download_id: download.id)
          #   dr.update_attributes download_category_id: category.id

          #   csv resource.id, context[:curriculum].breadcrumb_title, resource.title ,"attach (with category '#{category.description}'): #{fname}"
          # end
        end

        def find_download_category(path)
          # dirname = path.dirname.split.last.to_s
          # category = dirname.parameterize.underscore

          # DownloadCategory.find_or_create_by(name: category) do |dc|
          #   dc.description = dirname
          # end
        end

        def csv(*attrs)
          puts attrs.map { |attr| "\"#{attr}\"" }.join(',')
        end
      end
  end
end
