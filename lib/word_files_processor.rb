module WordFilesProcessor
  extend Tools

  def self.process(dir)
    report :headers
    process_directory(dir)
  end

  # Recursively process files in the directory tree
  def self.process_directory(dir, context: Context.new)
    dir = ::Pathname.new(dir) unless dir.is_a? ::Pathname
    subdirectories(dir).each do |subdir|
      context.append!(path_to_parse: subdir)
      FileProcessor.new(subdir, context).process
      self.process_directory(subdir, context: context) # Dig deeper
    end

    context.pop! # Up one level. Forget trailing context details.
  end
end
