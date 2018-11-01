# frozen_string_literal: true

AdminMaterialsQuery.class_eval do
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

  def metadata_keys
    %i(type sheet_type breadcrumb_level subject)
  end

  def filter_by_source
    @scope = (q[:source] == 'pdf' ? @scope.pdf : @scope.gdoc) if q[:source].present?
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
end
