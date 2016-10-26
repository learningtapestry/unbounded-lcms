module WordFilesProcessor
  module Tools
    # @return [Array] of subdirectories. Full paths.
    def subdirectories(dir)
      fs_entries(dir, filter: ->(d) { ::File.directory?(d) })
    end

    # @return [Array] of Filename instances. Full paths.
    def array_of_files(dir)
      paths = fs_entries(dir, filter: ->(f) { ::File.file?(f) })
      paths.collect { |p| ::WordFilesProcessor::File.new(p) }
    end

    # Generic directory iterator
    # @return [Array] of files or directories. Full paths.
    def fs_entries(dir, filter:)
      fail ArgumentError, "Proc expected, #{filter.class.name} given" unless filter.is_a? Proc
      ::Dir.entries(dir).collect do |entry|
        next if (entry == '.' || entry == '..' || entry.start_with?('.'))
        fullpath = ::File.join(dir, entry)
        filter.call(fullpath) ? ::Pathname.new(fullpath) : nil
      end.compact
    end

    # Named captures as Hash
    def hash_of_named_captures(captures)
      Hash[captures.names.collect{|x| [x.to_sym, captures[x]]}]
    end

    def csv_fields
      [
        :curriculum_id,
        :resource_id,
        :resource_title,
        :category,
        :breadcrumb,
        :action,
        :filename_old,
        :filename
      ]
    end

    # Debug report
    def report(row)
      if row == :headers
        puts csv_fields.map(&:to_s).join(',')
      else
        puts csv_fields.map { |key| "\"#{row[key].to_s}\"" }.join(',')
      end
    end
  end
end

