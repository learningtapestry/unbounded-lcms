class ResourcesController < ApplicationController
  before_action :find_resource

  def show
    @resource = ResourcePresenter.new(@resource)
  end

  def preview
    render json: @resource, serializer: ResourcePreviewSerializer
  end

  private
    def find_resource
      if id = params[:id]
        @resource = Resource.find(id)
      elsif slug = params[:slug]
        slug = ResourceSlug.find_by_value!(slug)
        @resource = slug.resource
        @curriculum = UnboundedCurriculum.new(slug.resource_collection, @resource)
      end
    end
end
