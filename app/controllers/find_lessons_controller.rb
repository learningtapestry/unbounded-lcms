class FindLessonsController < ApplicationController
  before_action :fix_search_params

  def index
    lessons = Resource.lessons.send(params[:sort_by])
                      .paginate(page: params[:page],
                                per_page: params[:show_by])
    @props = PaginationSerializer.new(lessons,
                                      sort_by: params[:sort_by],
                                      each_serializer: LessonSerializer)
                                 .as_json
  end

  protected

  def fix_search_params
    params[:page] = (params[:page].try(:to_i) || 1)
    params[:sort_by] = %w(asc desc).include?(params[:sort_by]) ? params[:sort_by] : 'asc'
    params[:show_by] = (params[:show_by].try(:to_i) || 12)
  end
end
