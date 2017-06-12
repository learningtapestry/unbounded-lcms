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
        # when 'mid', we get the unit refered on 'after-topic'
        context[:unit] = "topic #{metadata['after-topic']}"
        Curriculum.find_by_context(context)
      else
        # when 'end', we get the last unit on the module
        mod = Curriculum.find_by_context(context)
        mod.children.last
      end
    end
  end

  def assessment
    @assessment ||= unit.children.detect { |c| c.resource.assessment? }
  end

  def default_title
    mid? ? 'Mid-Unit Assessment' : 'End-Unit Assessment'
  end

  def create_resource
    resource = Resource.create!(
      curriculum_directory: [
        context[:subject],
        context[:grade],
        context[:module],
        context[:unit],
        metadata['type']
      ].compact,
      grade_list: [context[:grade]],
      resource_type: Resource.resource_types[:resource],
      short_title: 'assessment',
      subject: context[:subject],
      tag_list: ['assessment', metadata['type']],
      teaser: metadata['teaser'],
      title: metadata['title']
    )
    unit.children.create!(item: resource, curriculum_type: CurriculumType.lesson)
    resource
  end
end
