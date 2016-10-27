module WordFilesProcessor
  class FileProcessor
    include Tools

    attr_reader :context

    def initialize(dir, context)
      @dir = dir
      @context = context
    end

    def files
      @files ||= array_of_files(@dir)
    end

    def dirname
      @dirname ||= @dir.basename.to_s
    end

    def process
      case context[:download_level]
      when :module
        add_files_to_module
      when :unit
        add_files_to_unit
      when :lesson
        add_files_to_lessons
      end
    end

    def add_files_to_module
      category  = dirname.ends_with?(c = "Rubrics and Tools") ? c : nil
      files.each do |file|
        c = CurriculumFinder.new(file, context).find
        report c.merge(category: category, dir: file.filepath.dirname, filename_old: nil, filename: file.basename, action: 'add')
      end
    end

    def add_files_to_unit
      # first remove all unit files
      c = CurriculumFinder.new(files.first, context).find
      report c.merge(dir: files.first.filepath.dirname, filename_old: nil, filename: nil, action: 'remove')

      files.each do |file|
        c = CurriculumFinder.new(file, context).find
        report c.merge(dir: file.filepath.dirname, filename_old: nil, filename: file.basename, action: 'add')
      end
    end

    def add_files_to_lessons
      c = "Rubrics and Tools"
      category = dirname == c ? c : nil
      subject = context[:subject]

      files.each do |file|
        new_filename = file.recommended_filename(extra_fields: {subject: subject})

        c = CurriculumFinder.new(file, context).find
        report c.merge(category: category, dir: file.filepath.dirname, filename_old: file.basename, filename: new_filename, action: 'add')
      end
    end
  end
end

