require 'content/models'

class ApiController < ApplicationController
  before_action :remove_blank_params

  def show_resources
    q = ApiSearch.new(params)
    @results = q.results
    @total_count = q.total_count
    api_response
  end

  def show_alignments
    options = {
      entity: Alignment,
      join_entity: LobjectAlignment
    }

    q = ApiResourceCount.new(params, options) do |query|
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
    end

    @results = q.results
    @total_count = q.total_count

    api_response
  end

  def show_subjects
    options = {
      entity: Subject,
      join_entity: LobjectSubject
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
      join_entity: LobjectIdentity
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
    response.headers['x-total-count'] = @total_count.to_s
    render json: @results, root: nil
  end
end
