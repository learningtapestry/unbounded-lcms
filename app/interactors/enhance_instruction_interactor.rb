class EnhanceInstructionInteractor < BaseInteractor
  TAB_INDEX = %i(instructions videos generic).freeze

  attr_reader :props

  def run
    @props = pagination.serialize(data, serializer)
    @props.merge!(filterbar.props)
    @props.merge!(tab: active_tab)
  end

  private

  def filterbar
    @filterbar ||= Filterbar.new(params)
  end

  def pagination
    @pagination ||= Pagination.new(params)
  end

  def active_tab
    @active_tab ||= (params[:tab] || 0).to_i
  end

  def tab(name)
    TAB_INDEX.index(name)
  end

  def data
    case active_tab
    when tab(:instructions) then content_guides
    when tab(:videos) then resources(:media)
    else resources(:generic_resources)
    end
  end

  def serializer
    active_tab == tab(:instructions) ? InstructionSerializer : ResourceInstructionSerializer
  end

  def content_guides
    ContentGuide
      .where_subject(filterbar.subjects)
      .where_grade(filterbar.grades)
      .distinct
      .sort_by_grade
      .paginate(pagination.params(strict: true))
  end

  def resources(type)
    Resource
      .send(type)
      .where_subject(filterbar.subjects)
      .where_grade(filterbar.grades)
      .ordered
      .paginate(pagination.params(strict: true))
  end
end
