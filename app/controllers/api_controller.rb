require 'content/models'

class ApiController < ApplicationController
  include Content::Models

  before_action :remove_blank_params

  def show_resources
    api_search = ApiSearch.new(params)
    @results = api_search.results
    @total_count = @results[:results].size.to_s
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
        query.where!('lower(alignments.name) like ?', "%#{params[:name].downcase}%")
      end

      if params[:framework]
        query.where!('lower(alignments.framework) like ?', "%#{params[:framework].downcase}%")
      end

      if params[:framework_url]
        query.where!('lower(alignments.framework_url) like ?', "%#{params[:framework_url].downcase}%")
      end

      query
    end.results

    @total_count = @results.size.to_s

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
        query.where!('lower(subjects.name) like ?', "%#{params[:name].downcase}%")
      end

      query
    end.results

    @total_count = @results.size.to_s

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
        query.where!('lower(identities.name) like ?', "%#{params[:name].downcase}%")
      end

      query
    end.results

    @total_count = @results.size.to_s

    api_response
  end

  protected

  def remove_blank_params
    params.reject! { |k,v| v.blank? }
  end

  def api_response
    response.headers['x-total-count'] = @total_count
    render json: @results, root: nil
  end
end
