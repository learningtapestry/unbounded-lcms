require 'staccato/adapter/logger'
class SearchController < ApplicationController
  include Filterbar
  include Pagination

  before_action :find_documents
  before_action :set_props
  before_action :ping_ga

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  protected

    def ping_ga
      return unless cookies['_ga'].present?
      ga_client_id = cookies['_ga'].split('.').last(2).join('.')
      #ga_client_id = "fjwndghlalwerj"
      search_term = params["search_term"]
      tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], ga_client_id) do |c|
        c.adapter = Staccato::Adapter::Logger.new(
          Staccato.ga_collection_uri, Logger.new(STDOUT), lambda {|params| JSON.dump(params)}
        )
      end


      #tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], ga_client_id)
      #uri = URI(request.referer).path + "&" + {"search_term" => search_term}.to_query
      ga_params = {path: request.fullpath, referrer: request.referer}
      tracker.pageview(ga_params)
    end

    def find_documents
      @documents = Search::Document.search(search_term, search_params).paginate(pagination_params)
    end

    def set_props
      @props = serialize_with_pagination(@documents,
        pagination: pagination_params,
        each_serializer: SearchDocumentSerializer
      )
      @props.merge!(filterbar_props)
    end
end

