module Pagination
  extend ActiveSupport::Concern

  included do
    def pagination_params
      @pagination ||= begin
        default_params = { page: 1, per_page: 12, order: :asc }
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
      options = {}
      options[:meta_key] = :pagination
      options[:pagination] = {
        total_pages: resources.total_pages,
        current_page: resources.current_page,
        per_page: resources.per_page,
        order: pagination[:order],
        total_hits: resources.total_entries
      }
      options[:each_serializer] = each_serializer
      PaginationSerializer.new(resources, options).as_json
    end
  end
end
