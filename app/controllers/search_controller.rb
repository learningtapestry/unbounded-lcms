class SearchController < ApplicationController
  include Filterbar
  include Pagination

  before_action :find_documents
  before_action :set_props

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  protected

    def find_documents
      options = pagination_params.slice(:page, :per_page)

      # handle filters
      options.merge!(model_type: facets_params.first) if facets_params.size == 1
      options.merge!(subject: subject_params.first) if subject_params.present?

      @documents = Search::Document.search(search_term, options).paginate(options)
    end

    def set_props
      @props = serialize_with_pagination(@documents,
        pagination: pagination_params,
        each_serializer: SearchDocumentSerializer
      )
      @props.merge!(filterbar_props)
    end
end
