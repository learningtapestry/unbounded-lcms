class Admin::ComponentsController < Admin::AdminController
  include Pagination

  def index
    @q = OpenStruct.new(query_params)
    @components = Component.search(search_params)
  end

  def show
    @component = Component.find(params[:id])
  end

  protected

    def query_params
      @query_params ||= params.fetch(:q, {}).select do |key, val|
        val.is_a?(Array) ?  val.any?(&:present?) : val.present?
      end
    end

    def search_params
      query_params.merge(pagination_params)
    end
end

