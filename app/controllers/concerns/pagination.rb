module Pagination
  extend ActiveSupport::Concern

  included do
    def pagination_params
      @pagination_params ||= begin
        default_params = { page: 1, per_page: 20, order: :asc }
        expected_params = params.slice(:page, :per_page, :order).symbolize_keys
        pagination = default_params.merge(expected_params)

        pagination[:page] = pagination[:page].to_i
        pagination[:per_page] = pagination[:per_page].to_i
        pagination[:order] = pagination[:order].to_sym

        raise StandardError unless pagination[:page] > 0
        raise StandardError unless pagination[:per_page] > 0
        raise StandardError unless [:asc, :desc].include? pagination[:order]

        pagination
      end
    end

    def serialize_with_pagination(resources, pagination:, each_serializer:)
      options = { root: :results }
      options[:meta_key] = :pagination
      options[:pagination] = {
        total_pages: resources.total_pages,
        current_page: resources.current_page,
        per_page: resources.per_page,
        order: pagination[:order],
        total_hits: resources.total_entries
      }
      options[:each_serializer] = each_serializer
      ActiveModel::ArraySerializer.new(resources, options).as_json
    end

    def paginate_es_response(res, options)
      pagination_attrs = {
        total_pages:   (res.total.to_f / options[:per_page]).ceil,
        current_page:  options[:page],
        per_page:      options[:per_page],
        total_entries: res.total,
      }
      res.instance_variable_set :@_pagination_attrs, pagination_attrs
      def res.total_pages;   @_pagination_attrs[:total_pages]   end
      def res.current_page;  @_pagination_attrs[:current_page]  end
      def res.per_page;      @_pagination_attrs[:per_page]      end
      def res.total_entries; @_pagination_attrs[:total_entries] end
      res
    end
  end
end
