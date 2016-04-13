class Admin::ResourcePickerController < Admin::AdminController
  include Pagination

  class ResourcePickerSerializer < ActiveModel::Serializer
    self.root = false
    attributes :id, :title
  end

  def index
    @resources = Resource

    if index_params[:subject].present?
      @resources = @resources.where_subject(index_params[:subject])
    end

    if index_params[:type].present?
      @resources = @resources.joins(:curriculums)
      .where(curriculums: {
        curriculum_type: FilterParamsConstants.curriculum_types[index_params[:type]]
      })
      .where(curriculums: { seed_id: nil })
    end

    if index_params[:grade].present?
      @resources = @resources.where_grade(
        FilterParamsConstants.grades[index_params[:grade]]
      )
    end

    if index_params[:q].present?
      @resources = @resources.where('title ilike ?', "%#{params[:q]}%")
    end

    @resources = @resources
      .paginate(page: pagination_params[:page], per_page: 10)
      .order("resources.title asc")

    respond_to do |format|
      format.json {
        json_response = serialize_with_pagination(@resources,
          pagination: pagination_params,
          each_serializer: ResourcePickerSerializer
        )
        render json: json_response
      }
    end
  end

  def index_params
    @index_params ||= begin
      default_params = { type: nil, subject: nil, grade: nil, q: nil }
      expected_params = params.slice(:type, :subject, :grade, :q).symbolize_keys
      index_p = default_params.merge(expected_params)

      grade_ok = index_p[:grade].blank? ||
        FilterParamsConstants.grades.keys.include?(index_p[:grade])

      type_ok = index_p[:type].blank? ||
        FilterParamsConstants.curriculum_types.keys.include?(index_p[:type])

      subject_ok = index_p[:subject].blank? ||
        FilterParamsConstants.subjects.include?(index_p[:subject])

      raise StandardError unless grade_ok && type_ok && subject_ok

      index_p
    end
  end
end
