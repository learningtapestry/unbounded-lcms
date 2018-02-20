# frozen_string_literal: true

# Usage:
#   @materials = AdminMaterialsQuery.call(query_params, page: params[:page])
class AdminMaterialsQuery
  def self.call(query, pagination = nil)
    new(query, pagination).call
  end

  # query : query params (Hash or OpenStruct)
  # pagination : pagination params, if pagination is nil whe return all results
  def initialize(query, pagination = nil)
    @q = OpenStruct.new(query)
    @pagination = pagination
  end

  # Returns: ActiveRecord relation
  def call
    @scope = Material.includes(documents: :resource).all # initial scope

    search_by_identifier
    filter_by_source
    filter_by_metadata
    filter_by_grade_and_lesson
    filter_by_module
    filter_by_unit

    if @pagination.present?
      sorted_scope.paginate(page: @pagination[:page])
    else
      sorted_scope
    end
  end

  private

  attr_reader :q

  def filter_by_source
    @scope = (q[:source] == 'pdf' ? @scope.pdf : @scope.gdoc) if q[:source].present?
  end

  def filter_by_metadata
    %i(type sheet_type breadcrumb_level subject).each do |key|
      @scope = @scope.where_metadata_like(key, q[key]) if q[key].present?
    end
  end

  def filter_by_grade_and_lesson
    %i(grade lesson).each do |key|
      @scope = @scope.joins(:documents).where('documents.metadata @> hstore(?, ?)', key, q[key]) if q[key].present?
    end
  end

  def filter_by_module
    return unless q[:module].present?

    sql = <<-SQL
        (documents.metadata @> hstore('subject', 'math') AND documents.metadata @> hstore('unit', :mod))
        OR (documents.metadata @> hstore('subject', 'ela') AND documents.metadata @> hstore('module', :mod))
    SQL
    @scope = @scope.joins(:documents).where(sql, mod: q[:module])
  end

  def filter_by_unit
    return unless q[:unit].present?

    sql = %((documents.metadata @> hstore('unit', :u) OR documents.metadata @> hstore('topic', :u)))
    @scope = @scope.joins(:documents).where(sql, u: q[:unit])
  end

  def search_by_identifier
    # we need the `with_pg_search_rank` scope for this to work with DISTINCT
    # See more on: https://github.com/Casecommons/pg_search/issues/238
    @scope = @scope.search_identifier(q.search_term).with_pg_search_rank if q.search_term.present?
  end

  def sorted_scope
    @scope = @scope.order(:identifier) if q.sort_by.blank? || q.sort_by == 'identifier'
    @scope = @scope.order(updated_at: :desc) if q.sort_by == 'last_update'
    @scope.uniq
  end
end
