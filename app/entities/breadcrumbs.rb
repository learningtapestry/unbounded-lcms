# frozen_string_literal: true

class Breadcrumbs
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  # ex:  "ELA / G2 / M1 / U1 / lesson 8"
  def title
    hierarchy.map do |key|
      if resource.curriculum_type.try(:to_sym) == key
        value = resource.curriculum_tags_for(key).first
        value =~ /topic/i ? value.upcase.sub('TOPIC', 'topic') : value
      else
        send(:"#{key}_abbrv")
      end
    end.compact.join(' / ')
  end

  def short_title
    hierarchy.map { |key| send(:"#{key}_abbrv", short: true) }.compact.join(' / ')
  end

  def full_title
    hierarchy.map do |key|
      val = resource.curriculum_tags_for(key).first
      key == :subject ? val.try(:upcase) : val.try(:humanize)
    end.compact.join(' / ')
  end

  private

  def hierarchy
    Resource::HIERARCHY
  end

  def subject_abbrv(short: false)
    if short
      resource.ela? ? 'EL' : 'MA'
    else
      resource.ela? ? 'ELA' : 'Math'
    end
  end

  def grade_abbrv(*)
    case grade = resource.curriculum_tags_for(:grade).first
    when 'prekindergarten' then 'PK'
    when 'kindergarten' then 'K'
    when /grade/i then "G#{grade.match(/grade (\d+)/i)[1]}"
    end
  end

  def module_abbrv(*)
    # TODO: handle special case modules (when/if needed)
    # -  writing -> WM
    # -  core proficiencies -> CP
    # -  extension -> EM
    # -  skills -> Skills
    # -  listening and learning -> LL
    # -  literary criticism -> LC
    module_ = resource.curriculum_tags_for(:module).first
    "M#{module_.match(/module (\d+)/i)[1]}" if module_
  end

  def unit_abbrv(*)
    unit = resource.curriculum_tags_for(:unit).first
    return unless unit

    prefix = case unit
             when /topic/i then 'T'
             when /assessment/i then 'A'
             else 'U'
             end
    "#{prefix}#{unit.match(/(unit|topic) (.*)/i).try(:[], 2).try(:upcase)}"
  end

  def lesson_abbrv(*)
    lesson = resource.curriculum_tags_for(:lesson).first
    return unless lesson

    prefix = lesson =~ /part/i ? 'P' : 'L'

    "#{prefix}#{lesson.match(/(lesson|part) (\d+)/i).try(:[], 2)}"
  end
end
