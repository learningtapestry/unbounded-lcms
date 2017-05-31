class HierarchicalPosition
  RESOURCE_TYPE_ORDER = %w(resource media quick_reference_guide text_set).freeze

  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  # Position mask:
  # - We use 7 blocks of 2 numbers for:
  #     subject, resource_types, grades (average if more than one), module, unit,
  #     lesson, num_of_grades
  # - The last position is the number of different grades covered, i.e:
  #   a resource with 3 different grades show after one with 2, (more specific
  #   at the top, more generic at the bottom)
  def position
    return default_position if index.present? && dettached_resource?

    vals = index[resource_curriculum_key] || index[resource.subject]
    return default_position unless vals.present?

    [
      vals.first, # subject
      resource_type_pos, # resource_type
      resource.grades.average_number, # grades
      vals[2], # module
      vals[3], # unit
      lesson_pos, # lesson
      resource.grades.list.size # number of grades
    ].map { |v| v.to_s.rjust(2, '0') }.join(' ')
  end

  private

  def index
    @index ||= CurriculumTree.positions_index
  end

  def default_position
    @default_position ||= Array.new(7, '99').join(' ')
  end

  def resource_type_pos
    type = resource.media? ? 'media' : resource.resource_type
    RESOURCE_TYPE_ORDER.index(type)
  end

  def dettached_resource?
    resource.resource? && CurriculumTree.default.present? && !resource.tree?
  end

  def resource_curriculum_key
    dir = resource.lesson? ? resource.curriculum[0...-1] : resource.curriculum
    dir.join('|')
  end

  def lesson_pos
    lesson = resource.curriculum_tags_for(:lesson).first
    lesson =~ /assessment/ ? 99 : lesson.try(:match, /(\d+)/).try(:[], 1).to_i
  end
end
