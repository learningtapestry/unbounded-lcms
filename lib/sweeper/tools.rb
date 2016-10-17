
class Sweeper; module Tools

  # @return [Array] of subdirectories. Full paths.
  def subdirectories(dir)
    fs_entries(dir, filter: ->(d) { ::File.directory?(d) })
  end


  # @return [Array] of Filename instances. Full paths.
  def array_of_files(dir)
    paths = fs_entries(dir, filter: ->(f) { ::File.file?(f) })
    paths.collect { |p| ::Sweeper::File.new(p) }
  end


  # Generic directory iterator
  # @return [Array] of files or directories. Full paths.
  def fs_entries(dir, filter:)
    fail ArgumentError, "Proc expected, #{filter.class.name} given" unless filter.is_a? Proc
    ::Dir.entries(dir).collect do |entry|
      next if (entry =='.' || entry == '..')
      fullpath = ::File.join(dir, entry)
      filter.call(fullpath) ? ::Pathname.new(fullpath) : nil
    end.compact
  end

  # Named captures as Hash
  def hash_of_named_captures(captures)
    Hash[captures.names.collect{|x| [x.to_sym, captures[x]]}]
  end

  # Debug report
  def report(text)
    puts "--- #{text}"
  end


end; end

