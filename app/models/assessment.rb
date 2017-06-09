# TODO: This will should go to entities after the refactor is merged
class Assessment
  attr_reader :context, :metadata

  def initialize(context, metadata)
    @context = context
    @metadata = metadata
  end

  def find_or_create
    if assessment
      assessment.resource
    else
      create_resource
    end
  end

  def fix_metadata!
    metadata['title'] = metadata['title'].presence || default_title
    metadata['teaser'] = metadata['title'].presence || default_title
    self
  end

  private

  def mid?
    metadata['type'] == 'assessment-mid'
  end

  def unit
    @unit ||= begin
      if mid?
        context[:unit] = "topic #{metadata['after-topic']}"
        Curriculum.find_by_context(context)
      else
        mod = Curriculum.find_by_context(context)
        mod.children.last
      end
    end
  end

  def assessment
    @assessment ||= unit.children.detect { |c| c.resource.assessment? }
  end

  def default_title
    (mid? ? 'Mid-Unit Assessment' : 'End-Unit Assessment')
  end

  def create_resource
    resource = Resource.create!(
      resource_type: Resource.resource_types[:resource],
      title: metadata['title'],
      teaser: metadata['teaser'],
      subject: context[:subject],
      short_title: 'assessment',
      grade_list: [context[:grade]],
      curriculum_directory: [
        context[:subject],
        context[:grade],
        context[:module],
        context[:unit],
        metadata['type']
      ].compact,
      tag_list: ['assessment', metadata['type']]
    )
    unit.children.create!(item: resource, curriculum_type: CurriculumType.lesson)
    resource
  end
end
