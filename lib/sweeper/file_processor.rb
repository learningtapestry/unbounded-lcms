class Sweeper; class FileProcessor
  include Tools

  def add_files_to_lessons(files:, subject:, category: nil)
    files.each do |file|
      new_filename = file.recommended_filename(extra_fields: {subject: subject})
      report "mv '#{file.basename}' => '#{new_filename}'"
      if category.present?
        report "add '#{new_filename}' to the corresponding lesson under the '#{category}' category"
      else
        report "add '#{new_filename}' to the corresponding lesson"
      end
    end
  end

  def add_files_to_module(module_no:, files:, category: nil)
    files.each do |file|
      if category.present?
        report "add '#{file.basename}' to module #{module_no} under the '#{category}' category"
      else
        report "add '#{file.basename}' to module #{module_no}"
      end
    end
  end

  def add_files_to_unit(files:, unit:)
    files.each do |file|
      report "add '#{file.basename}' to unit #{unit}"
    end
  end

  def process_files(dir, context:)
    files = array_of_files(dir) # Array of ::Sweeper::File instances
    dirname = dir.basename.to_s

    case context[:download_level]
    when :module
      category  = dirname.ends_with?(c = "Rubrics and Tools") ? c : nil
      add_files_to_module(module_no: context[:module], files: files, category: category)
    when :lesson
      if dirname == "Lessons"
        add_files_to_lessons(files: files, subject: context[:subject])
      elsif dirname == "Rubrics and Tools"
        add_files_to_lessons(files: files, subject: context[:subject], category: "Rubrics and Tools")
      end
    when :unit
      add_files_to_unit(files: files, unit: context[:unit])
    else
      if context[:unit].present?
        report "Remove all files attached to unit #{context[:unit]}"
      end
    end
  end

end; end

