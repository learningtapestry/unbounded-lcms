class CurriculumContext
  CURRICULUM_PART_NUM_RE = /[grade|module|unit|topic|lesson|assessment|part] (.*)/

  attr_reader :ctx

  def initialize(ctx = {})
    @ctx = ctx.with_indifferent_access
  end

  def find_or_create_resource
    resource = Resource.tree.find_by(curriculum_directory: to_a)
    return resource if resource

    Resource.create!(
      curriculum_type: curriculum_type,
      curriculum_tree: CurriculumTree.default,
      curriculum_directory: to_a,
      resource_type: Resource.resource_types[:resource],
      short_title: short_title,
      tag_list: tag_list,
      teaser: teaser,
      title: title
    )
  end

  def to_h
    { subject: subject, grade: grade, module: mod, unit: unit, lesson: lesson }.compact
  end

  def to_a
    [subject, grade, mod, unit, lesson].compact
  end

  def curriculum_type
    CurriculumTree::HIERARCHY.reverse.detect { |level| send(level).present? }
  end

  def subject
    @subject ||= begin
      value = ctx[:subject].try(:downcase)
      value if CurriculumTree::SUBJECTS.include?(value)
    end
  end

  def grade
    @grade ||= begin
      value = ctx[:grade].try(:downcase)
      value = "grade #{value}" if number?(value)
      value if Grades::GRADES.include?(value)
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
      unit = Resource.tree.units.where_curriculum(directory: module_dir).ordered.last
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
        part.first.upcase + part.match(CURRICULUM_PART_NUM_RE).try(:[], 1)
      end.join(' ')
      "#{subject.upcase} #{parts}"
    end
  end

  def short_title
    to_a.last
  end

  def teaser
    ctx[:teaser].presence || (assessment? ? title : nil)
  end

  def tag_list
    if assessment?
      ['assessment', ctx['type']]
    else
      []
    end
  end

  def number?(str)
    str =~ /^\d+$/
  end
end
