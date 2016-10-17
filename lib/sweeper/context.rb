class Sweeper; class Context

  def initialize
    @chain = [] # Array of hashes. Will grow as we dive deeper to subdirs
  end

  def inspect
    @chain.inspect
  end

  def to_h
    @chain.reduce({}, :merge)
  end

  def [](key)
    self.to_h[key]
  end

  def depth
    @chain.size
  end

  def pop!
    @chain.pop
  end

  def append!(path_to_parse:)
    basename = path_to_parse.basename.to_s
    @chain << self.class.extract_as_hash(basename)
    self
  end

  def self.extract_as_hash(text)
    result = { # NOTE: DO NOT sort this hash by key here, plz
      subject: (/(Math|ELA)/).match(text).try(:[], 0),
      grade:   (/grade\s+([0-9]{1,2})/i).match(text).try(:[], 1),
      module: (/module\s+([0-9]+[A-D]{0,1})/i).match(text).try(:[], 1),
      unit:    (/unit\s+([0-9]{1,2})/i).match(text).try(:[], 1),
      topic:   (/topic\s+([A-Z]{1})/i).match(text).try(:[], 1),
      lesson:  (/lesson\s+([0-9]{1,3})/).match(text).try(:[], 1),
    }
    result[:download_level] = {
      /Module Level Downloads/i => :module,
      /Unit Level Downloads/i   => :unit,
      /Lesson Level Downloads/i => :lesson,
    }.detect { |k,v| k.match(text) }.try(:last)

    result.delete_if { |key, value| value.blank? }
  end

end; end

