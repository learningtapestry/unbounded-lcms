module Oneoff
  class Issue503
    attr_reader :input_path
    def initialize
      @input_path = ENV.fetch('INPUT')
    end

    def run
      csv_file = File.join(@input_path, 'ela_ckla.csv')
      # puts 'resource_id,breadcrumbs,resource_title,action'
      CSV.foreach(csv_file, headers: true) do |row|
        context = build_context(row)
        next if context.nil?

        ResourceHandler.new(context).run
        print '.'
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
        'listening and learning strand'
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
          when :unit   then unit_level_tasks
          when :lesson then lesson_level_tasks
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
          module_level_add_to_description
        end

        def unit_level_tasks
          remove_all_downloads
          create_zip_with_all_files
          unit_level_downloads
          save_add_to_description_for_lessons
        end

        def lesson_level_tasks
          update_description
          lesson_level_downloads
          add_to_each_lesson_downloads
          lesson_level_add_to_description
        end

        def remove_all_downloads
          if resource.downloads.count > 0
            ResourceDownload.where(resource_id: resource.id).delete_all if resource
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "remove downloads"
          end
        end

        def update_description
          desc = context[:row]['description']
          if desc.match /^students will/i
            desc = desc.gsub(/\n\s?/, "\n • ")                                        # add bullet points
                       .gsub(/\n • (\d)\. /) { ["\n", "&nbsp;"*4, "• #{$1}. "].join } # fix for numbered sublist
                       .gsub(/\n/, '<br />')                                          # preserve newlines on html
            resource.description = desc
            resource.save
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "fix description bullet lists"
          end
        end

        def build_path(*pieces)
          File.join(files_path, *pieces)
        end

        def all_downloads(folder)
          Dir[File.join(folder, '**/*')].each do |path|
            if File.file?(path)
              fname = File.basename(path, '.*')
              category = find_download_category(path)

              download = Download.create(file: File.open(path), title: fname)
              resource.downloads << download
              resource.save
              if category
                dr = ResourceDownload.find_by(download_id: download.id)
                dr.update_attributes download_category_id: category.id

                csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach (with category '#{category}': #{fname}"
              else
                csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{fname}"
              end
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
          all_downloads build_path(context[:module], "unit #{context[:unit]}", 'Unit Level Downloads')
        end

        def lesson_level_downloads
          all_downloads build_path(context[:module], "unit #{context[:unit]}", "lesson #{context[:lesson]}")
        end

        def add_to_each_lesson_downloads
          all_downloads build_path(context[:module], "unit #{context[:unit]}", "ADD TO ALL LESSON LEVELS")
        end

        def create_zip_with_all_files
          strand = context[:module] =~ /skills/ ? 'Skills' : 'Listening and Learning'

          zip_name = "ELA #{context[:grade].titleize} #{strand}, Unit #{context[:unit]} - All files"

          unit_path = build_path context[:module], "unit #{context[:unit]}"
          FileUtils.cd(unit_path) do
            # create file to contain zipped files
            FileUtils.mkdir_p zip_name

            # copy relevant files to be zipped
            FileUtils.cp_r(
              Dir[
                File.join('Unit Level Downloads', '*'),  # Unit level downloads, without the folder
                File.join('ADD TO ALL LESSON LEVELS', '*')  # All folders inside 'add to each lesson (part)'
              ],
              zip_name
            )

            # zip whole folder
            `zip -r "#{zip_name}.zip" "#{zip_name}"`

            # remove tmp folder
            FileUtils.rm_r zip_name
          end
          File.open(File.join(unit_path, zip_name + '.zip')) do |zipfile|
            download = Download.create(file: zipfile, title: zip_name)
            resource.downloads << download
            resource.save

            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "attach: #{zip_name}.zip"
          end
        end

        def valid_categories
          @@valid_categories ||= [
            'Ancillary Components',
          ]
        end

        def find_download_category(path)
          # path should contain both folders and the filename
          dirname = path.split('/')[-2]

          category_desc = valid_categories.select { |c| dirname.match(/#{c}/i) }.first
          if category_desc
            category_name = category_desc.parameterize.underscore

            DownloadCategory.find_or_create_by(name: category_name) do |dc|
              dc.description = category_desc
            end
          end
        end

        def module_level_add_to_description
          desc = context[:row]['add_to_description']
          if desc
            resource.description += "<br /><br />" + clean_text(desc)
            resource.save
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "add to description (module level)"
          end
        end

        def save_add_to_description_for_lessons
          @@add_to_description ||= {}
          add_to_desc = context[:row]['add_to_description']
          if add_to_desc
            @@add_to_description[context[:unit]] = "<br /><br />" + clean_text(add_to_desc)
          end
        end

        def lesson_level_add_to_description
          if @@add_to_description[context[:unit]]
            resource.description += @@add_to_description[context[:unit]]
            resource.save
            csv resource.id, context[:curriculum].breadcrumb_title, resource.title, "add to description (lesson level)"
          end
        end

        def clean_text(txt)
          txt.gsub(/ADD TO ALL LESSONS IN THIS DOMAIN\n/i, '')
             .gsub(/\u{10FC01}/, '')    # evil hidden char =/ .. that was hard to find
             .gsub(/\n/, '<br />')
        end

        def csv(*attrs)
          # puts attrs.map { |attr| "\"#{attr}\"" }.join(',')
        end
      end
  end
end
