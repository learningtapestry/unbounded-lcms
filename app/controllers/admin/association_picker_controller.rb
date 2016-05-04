class Admin::AssociationPickerController < Admin::AdminController
  include Pagination

  class AssociationItemSerializer < ActiveModel::Serializer
    self.root = false
    attributes :id, :name
  end

  def index
    association = index_params[:association]

    @items = case association
             when :content_sources then tag_scope('content_sources')
             when :grades then tag_scope('grades')
             when :topics then tag_scope('topics')
             when :tags then tag_scope('tags')
             when :reading_assignment_authors then ReadingAssignmentAuthor
             when :reading_assignment_texts then ReadingAssignmentText
             when :common_core_standards then CommonCoreStandard
             when :unbounded_standards then UnboundedStandard
             end

    if index_params[:q].present?
      @items = @items.where('name ilike ?', "%#{params[:q]}%")
    end

    @items = @items
      .paginate(page: pagination_params[:page], per_page: 10)
      .order("name asc")

    respond_to do |format|
      format.json {
        json_response = serialize_with_pagination(@items,
          pagination: pagination_params,
          each_serializer: AssociationItemSerializer
        )
        render json: json_response
      }
    end
  end

  def index_params
    @index_params ||= begin
      default_params = { q: nil }
      expected_params = params.slice(:association, :q).symbolize_keys
      index_p = default_params.merge(expected_params)

      valid_assocs = [
        'content_sources', 'grades', 'topics', 'tags',
        'reading_assignment_authors', 'reading_assignment_texts',
        'common_core_standards', 'unbounded_standards'
      ]
      association_ok = valid_assocs.include?(index_p[:association])

      raise StandardError unless association_ok

      index_p[:association] = index_p[:association].to_sym

      index_p
    end
  end

  def tag_scope(context)
    Tag.where_context(context).select(:id, :name).distinct(:name)
  end
end
