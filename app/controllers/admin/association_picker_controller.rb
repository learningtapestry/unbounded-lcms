module Admin
  class AssociationPickerController < AdminController
    VALID_ASSOCIATIONS = %w(
      content_sources grades topics tags
      reading_assignment_authors reading_assignment_texts
      common_core_standards unbounded_standards
    ).freeze

    def index
      @items = association_items
      @items = @items.where('name ilike ?', "%#{params[:q]}%") if index_params[:q].present?
      @items = @items.paginate(page: pagination.params[:page], per_page: 10).order('name asc')

      respond_to do |format|
        format.json { render json: pagination.serialize(@items, AssociationItemSerializer) }
      end
    end

    private

    def pagination
      @pagination ||= Pagination.new(params)
    end

    def index_params
      @index_params ||= begin
        default_params = { q: nil }
        expected_params = params.slice(:association, :q).symbolize_keys
        index_p = default_params.merge(expected_params)

        raise StandardError unless VALID_ASSOCIATIONS.include?(index_p[:association])

        index_p[:association] = index_p[:association].to_sym
        index_p
      end
    end

    def association_items # rubocop:disable Metrics/CyclomaticComplexity
      case index_params[:association]
      when :content_sources then tag_scope('content_sources')
      when :grades then tag_scope('grades')
      when :topics then tag_scope('topics')
      when :tags then tag_scope('tags')
      when :reading_assignment_authors then ReadingAssignmentAuthor
      when :reading_assignment_texts then ReadingAssignmentText
      when :common_core_standards then CommonCoreStandard
      when :unbounded_standards then UnboundedStandard
      end
    end

    def tag_scope(context)
      Tag.where_context(context).select(:id, :name).distinct(:name)
    end
  end
end
