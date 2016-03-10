module Searchbar
  extend ActiveSupport::Concern

  included do
    def facets_params
      Array.wrap(params[:facets]) & [
        'curriculum', 'instructions'
      ]
    end

    def search_term
      params[:search_term] || ''
    end

    def searchbar_props
      {
        searchbar: {
          facets: facets_params,
          input: search_term
        }
      }
    end
  end
end
