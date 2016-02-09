class ResourcesController < ApplicationController
  before_action :find_resource

  def show
    if params[:id].present? && slug = @resource.slug
      redirect_to show_with_slug_path(slug), status: 301
    else
      @resource = ResourcePresenter.new(@resource)
    end
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

        if collection = slug.resource_collection
          @curriculum = UnboundedCurriculum.new(collection, @resource)
        end
      end
    end
end
