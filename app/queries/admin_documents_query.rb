# frozen_string_literal: true

# Usage:
#   @documents = AdminDocumentsQuery.call(query_params, page: params[:page])
#
class AdminDocumentsQuery
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
    @scope = Document.all # initial scope
    apply_filters

    if @pagination.present?
      sorted_scope.paginate(page: @pagination[:page])
    else
      sorted_scope
    end
  end

  private

  attr_reader :q

  def apply_filters
    @scope = @scope.actives unless q.inactive == '1'
    @scope = @scope.failed if q.only_failed == '1'
    @scope = @scope.filter_by_term(q.search_term) if q.search_term.present?
    @scope = @scope.filter_by_subject(q.subject) if q.subject.present?
    @scope = @scope.filter_by_grade(q.grade) if q.grade.present?
    @scope = @scope.filter_by_module(q.module) if q.module.present?
    @scope = @scope.filter_by_unit(q.unit) if q.unit.present?
    @scope = @scope.with_broken_materials if q.broken_materials == '1'
    @scope = @scope.with_updated_materials if q.reimport_required == '1'
    @scope
  end

  def sorted_scope
    @scope = @scope.order_by_curriculum if q.sort_by.blank? || q.sort_by == 'curriculum'
    @scope = @scope.order(updated_at: :desc) if q.sort_by == 'last_update'
    @scope.uniq.order(active: :desc)
  end
end
