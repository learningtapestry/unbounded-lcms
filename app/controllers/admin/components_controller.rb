module Admin
  class ComponentsController < AdminController
    def index
      @form = OpenStruct.new(query_params)
      @components = Component.search(search_params)
    end

    def show
      @component = Component.find(params[:id])
    end

    protected

    def pagination
      @pagination ||= Pagination.new(params)
    end

    def query_params
      @query_params ||= params.fetch(:form, {}).select do |_key, val|
        val.is_a?(Array) ? val.any?(&:present?) : val.present?
      end
    end

    def search_params
      query_params.merge(pagination.params)
    end
  end
end
