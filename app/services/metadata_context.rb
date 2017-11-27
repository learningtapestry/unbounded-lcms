# frozen_string_literal: true

#
# Handles Document metadata contexts, to find and/or create corresponding Resources
#
class MetadataContext
  attr_reader :ctx

  def initialize(ctx = {})
    @ctx = ctx.with_indifferent_access
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def curriculum
    @curriculum ||= [subject, grade, mod, unit, lesson].select(&:present?)
  end

  def find_or_create_resource
    # if the resource exists, return it
    resource = Resource.find_by_curriculum(curriculum)
    return resource if resource

    # else, build missing parents until we build the resource itself.
    parent = nil
    curriculum.each_with_index do |name, index|
      resource = Resource.tree.find_by_curriculum(curriculum[0..index])
      if resource
        parent = resource
        next
      end

      resource = build_new_resource(parent, name, index)
      if last_item(index) && mid_assessment?
        unit = parent.children.detect { |r| r.short_title =~ /topic #{ctx['after-topic']}/i }
        unit.append_sibling(resource)

      elsif last_item(index) && prerequisite?
        next_lesson = parent.children.detect do |r|
          break r unless r.prerequisite? # first non-prereq

          # first prereq lesson with a bigger lesson num
          lesson_num = r.short_title.match(/(\d+)/)&.[](1).to_i
          lesson_num > ctx[:lesson].to_i
        end
        next_lesson&.prepend_sibling(resource)

      elsif last_item(index) && opr?
        first_non_opr = parent.children.detect { |r| !r.opr? }
        first_non_opr&.prepend_sibling(resource)

      else
        resource.save!
      end

      parent = resource
    end
    resource
  end

  private

  def assessment?
    type =~ /assessment/
  end

  def build_new_resource(parent, name, index)
    dir = curriculum[0..index]
    resource = Resource.new(
      curriculum_directory: dir,
      curriculum_type: parent.next_hierarchy_level,
      level_position: parent.children.size,
      parent_id: parent.id,
      resource_type: :resource,
      short_title: name,
      tree: true
    )
    if last_item(index)
      resource.tag_list = tag_list if resource.lesson?
      resource.teaser = teaser
      resource.title = title
    else
      resource.title = default_title(dir)
    end
    resource
  end

  def default_title(curr = nil)
    if assessment?
      mid_assessment? ? 'Mid-Unit Assessment' : 'End-Unit Assessment'
    else
      # ELA G1 M1 U2 Lesson 1
      curr ||= curriculum
      res = Resource.new(curriculum_directory: curr)
      Breadcrumbs.new(res).title.split(' / ')[0...-1].push(curr.last.titleize).join(' ')
    end
  end

  def ela?
    subject.to_s.casecmp('ela').zero?
  end

  def grade
    @grade ||= begin
      value = ctx[:grade].try(:downcase)
      value = "grade #{value}" if number?(value)
      value # if Grades::GRADES.include?(value)
    end
  end

  def last_item(index)
    index == curriculum.size - 1
  end

  def lesson
    @lesson ||= begin
      return nil if assessment? # assessment is a unit now, so lesson -> nil

      num = if ela? && prerequisite?
              RomanNumerals.to_roman(ctx[:lesson].to_i)&.downcase
            else
              ctx[:lesson].presence
            end
      "lesson #{num}" if num.present?
    end
  end

  def mid_assessment?
    type.to_s.casecmp('assessment-mid').zero?
  end

  def module
    @module ||= begin
      mod = ela? ? ctx[:module] : ctx[:unit]
      alnum?(mod) && !mod.include?('strand') ? "module #{mod.downcase}" : mod
    end
  end
  alias :mod :module # rubocop:disable Style/Alias

  def number?(str)
    str =~ /^\d+$/
  end

  def alnum?(str)
    str =~ /^\w+$/
  end

  # `Optional prerequisite` - https://github.com/learningtapestry/unbounded/issues/557
  def opr?
    type.to_s.casecmp('opr').zero?
  end

  def prerequisite?
    type.to_s.casecmp('prereq').zero?
  end

  def subject
    @subject ||= begin
      value = ctx[:subject]&.downcase
      value if Resource::SUBJECTS.include?(value)
    end
  end

  def tag_list
    assessment? ? ['assessment', type] : [type.presence || 'core'] # lesson => prereq || core
  end

  def teaser
    ctx[:teaser].presence || (assessment? ? title : nil)
  end

  def title
    ctx[:title].presence || default_title
  end

  def type
    ctx[:type]&.downcase
  end

  def unit
    @unit ||= begin
      if assessment?
        type # assessment-mid || assessment-end
      else
        ela? ? "unit #{ctx[:unit]}" : "topic #{ctx[:topic]}"
      end
    end
  end
end
