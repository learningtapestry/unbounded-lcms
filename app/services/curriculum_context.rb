class CurriculumContext
  CURRICULUM_PART_NUM_RE = /(grade|module|unit|topic|lesson|assessment|part) (\w+)/i

  attr_reader :ctx

  def initialize(ctx = {})
    @ctx = ctx.with_indifferent_access
  end

  def find_or_create_resource
    curr = to_a
    # if the resource exists, return it
    resource = Resource.tree.find_by_curriculum(curr)
    return resource if resource

    # else, build missing parents until we build the resource itself.
    parent = nil
    curr.each_with_index do |name, index|
      dir = curr[0..index]
      resource = Resource.tree.find_by_curriculum(dir)
      if resource
        parent = resource
        next
      end

      resource = Resource.new(
        curriculum_directory: dir,
        curriculum_type: parent.next_hierarchy_level,
        level_position: parent.children.size,
        parent_id: parent.id,
        resource_type: :resource,
        short_title: name,
        tree: true
      )
      if index == curr.size - 1 # last item
        resource.tag_list = tag_list
        resource.teaser = teaser
        resource.title = title
      else
        resource.title = Breadcrumbs.new(resource).title.split(' / ')[0...-1].push(name.titleize).join(' ')
      end
      resource.save!
      parent = resource
    end
    resource
  end

  def to_h
    { subject: subject, grade: grade, module: mod, unit: unit, lesson: lesson }.compact
  end

  def to_a
    [subject, grade, mod, unit, lesson].compact
  end

  def subject
    @subject ||= begin
      value = ctx[:subject].try(:downcase)
      value if Resource::SUBJECTS.include?(value)
    end
  end

  def grade
    @grade ||= begin
      value = ctx[:grade].try(:downcase)
      value = "grade #{value}" if number?(value)
      value # if Grades::GRADES.include?(value)
    end
  end

  def module
    @module ||= begin
      mod = ela? ? ctx[:module] : ctx[:unit]
      number?(mod) && !mod.include?('strand') ? "module #{mod}" : mod
    end
  end
  alias :mod :module # rubocop:disable Style/Alias

  def unit
    @unit ||= begin
      if assessment?
        assessment_unit
      else
        ela? ? "unit #{ctx[:unit]}" : "topic #{ctx[:topic]}"
      end
    end
  end

  def assessment_unit
    if mid_assessment?
      # when 'mid', we get the unit refered on 'after-topic'
      "topic #{ctx['after-topic']}"
    else
      # when 'end', we get the last unit on the module
      module_dir = [subject, grade, mod]
      unit = Resource.tree.find_by_curriculum(module_dir).children.last
      unit.curriculum_tags_for(:unit).first
    end
  end

  def lesson
    @lesson ||= begin
      if assessment? then 'assessment'
      elsif number?(ctx[:lesson]) then "lesson #{ctx[:lesson]}"
      else ctx[:lesson]
      end
    end
  end

  private

  def ela?
    subject == 'ela'
  end

  def assessment?
    ctx[:type] =~ /assessment/
  end

  def mid_assessment?
    ctx[:type] == 'assessment-mid'
  end

  def title
    ctx[:title].presence || default_title
  end

  def default_title
    if assessment?
      mid? ? 'Mid-Unit Assessment' : 'End-Unit Assessment'
    else
      # ELA G1 M1 U2 L1
      parts = to_a[1..-1].map do |part|
        part.first.upcase + part.match(CURRICULUM_PART_NUM_RE).try(:[], 2).to_s
      end.join(' ')
      "#{subject.upcase} #{parts}"
    end
  end

  def teaser
    ctx[:teaser].presence || (assessment? ? title : nil)
  end

  def tag_list
    assessment? ? ['assessment', ctx['type']] : []
  end

  def number?(str)
    str =~ /^\d+$/
  end
end
