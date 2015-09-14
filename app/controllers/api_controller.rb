require 'content/models'

class ApiController < ApplicationController
  include Content::Models

  before_action :remove_blank_params

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
        query.where!('alignments.name like ?', "%#{params[:name]}%")
      end

      if params[:framework]
        query.where!('alignments.framework like ?', "%#{params[:framework]}%")
      end

      if params[:framework_url]
        query.where!('alignments.framework_url like ?', "%#{params[:framework_url]}%")
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
        query.where!('subjects.name like ?', "%#{params[:name]}%")
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
        query.where!('identities.name like ?', "%#{params[:name]}%")
      end

      query
    end.results

    api_response
  end

  protected

  def remove_blank_params
    params.reject! { |k,v| v.blank? }
  end

  def api_response
    response.headers['x-total-count'] = @results.size.to_s
    render json: @results
  end
end
