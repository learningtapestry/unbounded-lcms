# frozen_string_literal: true

EnhanceInstructionInteractor.class_eval do
  def data
    case active_tab
    when tab(:instructions) then
      content_guides
    when tab(:videos) then
      resources(:media)
    else
      resources(:generic_resources)
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
end
