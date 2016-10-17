class Sweeper
  include Tools

  def initialize
  end

  # Recursively process files in the directory tree
  def process_directory(dir, context: Context.new)
    dir = ::Pathname.new(dir) unless dir.is_a? ::Pathname

    subdirectories(dir).each do |subdir|
      report "\n-- DIR: #{subdir}"
      context.append!(path_to_parse: subdir)
      report "context: #{context.inspect}"
      FileProcessor.new.process_files(subdir, context: context)
      self.process_directory(subdir, context: context) # Dig deeper
    end

    context.pop! # Up one level. Forget trailing context details.
  end

end

require_dependency "sweeper/file"

