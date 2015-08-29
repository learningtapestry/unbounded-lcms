require 'content/models'
include Content::Models

class ApiController < ApplicationController
  before_action do
    @limit = params[:limit].try(:to_i) || 100
    @page = params[:page].try(:to_i) || 1
  end

  def show_resources
    @search_results = ApiSearch.new(params).results
    api_response
  end

  def show_alignments
    alignments_query = LobjectAlignment
    .select(:alignment_id, :lobject_id)
    .joins(:alignment)
    .joins(lobject: { lobject_documents: { document: :source_document } })
    .where('source_documents.source_type' => SourceDocument.source_types[:lr])
    .group(:alignment_id, :lobject_id)

    if params[:name]
      alignments_query = alignments_query
      .where('alignments.name like ?', "%#{params[:name]}%")
    end

    if params[:framework]
      alignments_query = alignments_query
      .where('alignments.framework like ?', "%#{params[:framework]}%")
    end

    if params[:framework_name]
      alignments_query = alignments_query
      .where('alignments.framework_name like ?', "%#{params[:framework_name]}%")
    end

    inner_sql = alignments_query.to_sql

    counts_sql = %{
      select
        a.alignment_id, count(*) as count
      from
        (#{inner_sql}) a
      group by
        a.alignment_id
      order by
        count(*) desc
      limit #{@limit}
      offset #{@limit * (@page-1)}
    }

    counts = ActiveRecord::Base.connection.execute(counts_sql)    
    alignments = Alignment.where(id: counts.map { |c| c['alignment_id'].to_i })

    i = 0
    @search_results = alignments.map do |alignment|
      result = {
        alignment: alignment,
        resource_count: counts[i]['count']
      }
      i += 1

      result
    end

    api_response
  end

  def show_subjects
    subjects_query = LobjectSubject
    .select(:subject_id, :lobject_id)
    .joins(:subject)
    .joins(lobject: { lobject_documents: { document: :source_document } })
    .where('source_documents.source_type' => SourceDocument.source_types[:lr])
    .group(:subject_id, :lobject_id)

    if params[:name]
      subjects_query = subjects_query
      .where('subjects.name like ?', "%#{params[:name]}%")
    end

    inner_sql = subjects_query.to_sql

    counts_sql = %{
      select
        a.subject_id, count(*) as count
      from
        (#{inner_sql}) a
      group by
        a.subject_id
      order by
        count(*) desc
      limit #{@limit}
      offset #{@limit * (@page-1)}
    }

    counts = ActiveRecord::Base.connection.execute(counts_sql)    
    subjects = Subject.where(id: counts.map { |c| c['subject_id'].to_i })

    i = 0
    @search_results = subjects.map do |subject|
      result = {
        subject: subject,
        resource_count: counts[i]['count']
      }
      i += 1

      result
    end

    api_response
  end

  def show_identities
    identities_query = LobjectIdentity
    .select(:identity_id, :lobject_id)
    .joins(:identity)
    .joins(lobject: { lobject_documents: { document: :source_document } })
    .where('source_documents.source_type' => SourceDocument.source_types[:lr])
    .group(:identity_id, :lobject_id)

    if params[:name]
      identities_query = identities_query
      .where('identities.name like ?', "%#{params[:name]}%")
    end

    inner_sql = identities_query.to_sql

    counts_sql = %{
      select
        a.identity_id, count(*) as count
      from
        (#{inner_sql}) a
      group by
        a.identity_id
      order by
        count(*) desc
      limit #{@limit}
      offset #{@limit * (@page-1)}
    }

    counts = ActiveRecord::Base.connection.execute(counts_sql)    
    identities = Identity.where(id: counts.map { |c| c['identity_id'].to_i })

    i = 0
    @search_results = identities.map do |identity|
      result = {
        identity: identity,
        resource_count: counts[i]['count']
      }
      i += 1

      result
    end

    api_response
  end

  protected

  def api_response
    response.headers['x-total-count'] = @search_results.size.to_s
    render json: @search_results
  end
end
