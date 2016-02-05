class Admin::CollectionTypesController < Admin::AdminController
  before_action :find_resource, except: [:index, :new, :create]

  def index
    @collection_types = ResourceCollectionType.all
  end

  def new
    @collection_type = ResourceCollectionType.new
  end

  def create
    @collection_type = ResourceCollectionType.new(collection_type_params)

    if @collection_type.save
      redirect_to admin_collection_type_url(@collection_type), notice: t('.success')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @collection_type.update_attributes(collection_type_params)
      redirect_to admin_collection_type_url(@collection_type), notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @collection_type.destroy
    redirect_to :admin_collection_types, notice: t('.success')
  end

  private
    def collection_type_params
      params.require('resource_collection_type').permit(:name)
    end

    def find_resource
      @collection_type = ResourceCollectionType.find(params[:id])
    end
end
