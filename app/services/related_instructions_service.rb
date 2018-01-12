class RelatedInstructionsService
  attr_reader :resource, :expanded, :has_more, :instructions

  def initialize(resource, expanded)
    @resource = resource
    @expanded = expanded

    find_related_instructions
  end

  private

  def find_related_instructions
    instructions = expanded ? expanded_instructions : colapsed_instructions

    @has_more = true if (videos + guides).size > instructions.size
    @instructions = instructions.map do |inst|
      if inst.is_a?(ContentGuide)
        InstructionSerializer.new(inst)
      else
        ResourceInstructionSerializer.new(inst)
      end
    end
  end

  def expanded_instructions
    guides + videos
  end

  def colapsed_instructions
    if guides.size > 1 # show 2 guides
      guides[0...2]
    elsif guides.size == 1 # show 1 guide and 2 videos
      guides[0...1] + videos[0...2]
    else # show 4 videos
      videos[0...4]
    end
  end

  def videos
    @videos ||= find_related_through_standards(limit: 4) do |standard|
      standard.resources.media.distinct
    end
  end

  def guides
    @guides ||= find_related_through_standards(limit: 2) do |standard| # rubocop:disable Style/SymbolProc
      standard.content_guides
    end
  end

  def find_related_through_standards(limit:, &_block)
    related = resource.unbounded_standards.flat_map do |standard|
      qset = yield standard
      qset = qset.limit(limit) unless expanded # limit each part
      qset
    end.uniq

    if expanded
      related
    else
      @has_more = true if related.count > limit
      related[0...limit] # limit total
    end
  end
end
