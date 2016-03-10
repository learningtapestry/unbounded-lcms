module Searchbar
  extend ActiveSupport::Concern

  included do

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
