class Admin::CollectionsController < Admin::AdminController
  before_action :find_resource, except: [:index, :new, :create]

  def index
    @collections = ResourceCollection.
                     select('resource_collections.id, resource_collection_type_id, resource_id, COUNT(resource_children.id) children_count').
                     joins('LEFT OUTER JOIN resource_children ON resource_children.resource_collection_id = resource_collections.id').
                     group('resource_collections.id, resource_collection_type_id, resource_id').
                     order(id: :desc).
                     includes(:resource_collection_type)
  end

  def new
    @collection = ResourceCollection.new
  end

  def create
    @collection = ResourceCollection.new(collection_params)

    if @collection.save
      redirect_to edit_admin_collection_url(@collection), notice: t('.success')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @collection.update_attributes(collection_params)
      redirect_to admin_collection_url(@collection), notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @collection.destroy
    redirect_to :admin_collections, notice: t('.success', collection_id: @collection.id)
  end

  private
    def collection_params
      params.require(:resource_collection).permit(:resource_collection_type_id, :resource_id, resource_children_attributes: [:_destroy, :child_id, :id, :parent_id, :position])
    end

    def find_resource
      @collection = ResourceCollection.find(params[:id])
    end
end
