# monkey patch ES results to handle pagination
module Elasticsearch
  module Persistence
    module Repository
      module Response

        class Results

          def paginate(options)
            @_pagination_attrs = {
              total_pages:   (total.to_f / options[:per_page]).ceil,
              current_page:  options[:page],
              per_page:      options[:per_page],
              total_entries: total,
            }
            self
          end

          def total_pages;   @_pagination_attrs[:total_pages]   end
          def current_page;  @_pagination_attrs[:current_page]  end
          def per_page;      @_pagination_attrs[:per_page]      end
          def total_entries; @_pagination_attrs[:total_entries] end

        end

      end
    end
  end
end
