require 'content/models'

class ApiController < ApplicationController
  before_action do
    @limit = params[:limit].try(:to_i) || 100
    @page = params[:page].try(:to_i) || 1
  end

  def show_resources
    @search_results = Searches::ApiSearch.new(params).search_results
    api_response
  end

  def show_alignments
    alignments = Content::Models::Alignment

    if params[:name]
      alignments = alignments.where('name like ?', "%#{params[:name]}%")
    end

    if params[:framework]
      alignments = alignments.where('framework like ?', "%#{params[:framework]}%")
    end

    if params[:framework_name]
      alignments = alignments.where('framework_name like ?', "%#{params[:framework_name]}%")
    end

    alignments = alignments.offset(@limit * (@page - 1)).limit(@limit)
    @search_results = Searches::SearchResults.new(results: resource_counts(alignments))
    api_response
  end

  def show_subjects
    subjects = Content::Models::Subject

    if params[:name]
      subjects = subjects.where('name like ?', "%#{params[:name]}%")
    end

    subjects = subjects.offset(@limit * (@page - 1)).limit(@limit)
    @search_results = Searches::SearchResults.new(results: resource_counts(subjects))
    api_response
  end

  def show_identities
    identities = Content::Models::Identity

    if params[:name]
      identities = identities.where('name like ?', "%#{params[:name]}%")
    end

    identities = identities.offset(@limit * (@page - 1)).limit(@limit)
    @search_results = Searches::SearchResults.new(results: resource_counts(identities))
    api_response
  end

  protected

  def api_response
    response.headers['x-total-count'] = @search_results.results.size.to_s
    render json: @search_results.results
  end

  def resource_counts(resources)
    table_name = resources.table.name
    attribute_name = table_name.singularize
    id_column = "#{attribute_name}_id"
    entity_ids = resources.pluck(:id).join(',')

    db_counts = ActiveRecord::Base.connection.execute(%{
      select
        e.#{id_column} as #{id_column}, count(*) as count
      from
        (select e.id as #{id_column}, le.lobject_id as lobject_id
         from #{table_name} e inner join lobject_#{table_name} le on e.id = le.#{id_column}
         where e.id in (#{entity_ids})
         group by e.id, le.lobject_id) e
      group by
        e.#{id_column}
      order by
        count(*) desc
    })

    resources_index = {}
    resources.each { |res| resources_index[res.id] = res }

    counts = []

    db_counts.each do |count|
      counts << {
        attribute_name => resources_index[count[id_column].to_i],
        'resource_count' => count['count']
      }
    end

    counts
  end
end
