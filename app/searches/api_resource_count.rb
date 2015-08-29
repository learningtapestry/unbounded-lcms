require 'content/models'
require 'content/search'

class ApiResourceCount
  attr_reader :results

  def initialize(params, entity:, join_entity:, source_type:)
    limit = params[:limit].try(:to_i) || 100
    page = params[:page].try(:to_i) || 1
    entity_name = entity.table_name.singularize.to_sym
    entity_id = "#{entity_name}_id".to_sym

    query = join_entity
    .select(entity_id, :lobject_id)
    .joins(entity_name)
    .joins(lobject: { lobject_documents: { document: :source_document } })
    .where('source_documents.source_type' => source_type)
    .group(entity_id, :lobject_id)

    query = yield query if block_given?

    inner_sql = query.to_sql

    counts_sql = %{
      select
        q.#{entity_id}, count(*) as count
      from
        (#{inner_sql}) q
      group by
        q.#{entity_id}
      order by
        count(*) desc
      limit #{limit}
      offset #{limit * (page-1)}
    }

    counts = ActiveRecord::Base.connection.execute(counts_sql)    
    entities = entity.where(id: counts.map { |e| e[entity_id.to_s].to_i })

    i = 0
    @results = entities.map do |e|
      result = {
        entity_name => e,
        resource_count: counts[i]['count']
      }
      i += 1

      result
    end
  end
end
