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
        rh = ResourceHandler.new(file, context)
        rh.report category: category, action: 'add'
        rh.create_db_assoc!
      end
    end

    def add_files_to_unit
      # first remove all unit files
      # rh = ResourceHandler.new(files.first, context)
      # rh.report filename: nil, action: 'remove'
      # rh.remove_all!

      files.each do |file|
        rh = ResourceHandler.new(file, context)
        rh.report action: 'add'
        rh.create_db_assoc!
      end
    end

    def add_files_to_lessons
      c = "Rubrics and Tools"
      category = dirname == c ? c : nil
      subject = context[:subject]

      files.each do |file|
        new_filename = file.recommended_filename(extra_fields: {subject: subject})
        ::File.rename(file.filepath.to_s, file.filepath.dirname.join(new_filename).to_s)

        rh = ResourceHandler.new(file, context)
        rh.report category: category, filename_old: file.basename, filename: new_filename, action: 'add'
        rh.create_db_assoc!
      end
    end
  end
end

