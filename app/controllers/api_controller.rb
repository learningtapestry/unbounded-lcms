require 'content/models'
include Content::Models

class ApiController < ApplicationController

  def show_resources
    @results = ApiSearch.new(params).results
    api_response
  end

  def show_alignments
    options = {
      entity: Alignment,
      join_entity: LobjectAlignment,
      source_type: SourceDocument.source_types[:lr]
    }

    @results = ApiResourceCount.new(params, options) do |query|
      if params[:name]
        query = query.where('alignments.name like ?', "%#{params[:name]}%")
      end

      if params[:framework]
        query = query.where('alignments.framework like ?', "%#{params[:framework]}%")
      end

      if params[:framework_url]
        query = query.where('alignments.framework_url like ?', "%#{params[:framework_url]}%")
      end

      query
    end.results

    api_response
  end

  def show_subjects
    options = {
      entity: Subject,
      join_entity: LobjectSubject,
      source_type: SourceDocument.source_types[:lr]
    }

    @results = ApiResourceCount.new(params, options) do |query|
      if params[:name]
        query = query.where('subjects.name like ?', "%#{params[:name]}%")
      end

      query
    end.results

    api_response
  end

  def show_identities
    options = {
      entity: Identity,
      join_entity: LobjectIdentity,
      source_type: SourceDocument.source_types[:lr]
    }

    @results = ApiResourceCount.new(params, options) do |query|
      if params[:name]
        query = query.where('identities.name like ?', "%#{params[:name]}%")
      end

      query
    end.results

    api_response
  end

  protected

  def api_response
    response.headers['x-total-count'] = @results.size.to_s
    render json: @results
  end
end
