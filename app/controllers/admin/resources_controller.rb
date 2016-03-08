class Admin::ResourcesController < Admin::AdminController
  before_action :find_resource, except: [:index, :new, :create]

  def index
    @q = Resource.ransack(params[:q])
    @resources = @q.result.
                   order(id: :desc).
                   includes(:standards, :grades, :resource_types, :subjects).
                   paginate(page: params[:page], per_page: 15)
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)

    if @resource.save
      redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @resource.update_attributes(resource_params)
      redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
    else
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
  end

  private
    def find_resource
      @resource = Resource.find(params[:id])
    end

    def resource_params
      params.
        require(:resource).
        permit(
                :description,
                :hidden,
                :short_title,
                :subtitle,
                :title,
                additional_resource_ids: [],
                standard_ids: [],
                grade_ids: [],
                resource_downloads_attributes: [:_destroy, :id, :download_category_id, { download_attributes: [:description, :file, :filename_cache, :id, :title] }],
                related_resource_ids: [],
                resource_type_ids: [],
                subject_ids: [],
                topic_ids: []
              )
    end
end
