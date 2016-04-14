class Admin::ResourcesController < Admin::AdminController
  before_action :find_resource, except: [:index, :new, :create]

  def index
    @q = Resource.ransack(params[:q])
    @resources = @q.result.
                   order(id: :desc).
                   includes(:standards, :taggings).
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
    @child_resources_hash = {}
  end

  def update
    unless Settings.editing_enabled?
      redirect_to :admin_resources, alert: t('admin.common.editing_disabled')
      return
    end

    @child_resources_hash = {}

    children_params = params.delete(:children) || []
    children_params.each do |curriculum_id, params|
      curriculum = @resource.curriculums.find_by_id(curriculum_id)
      next unless curriculum

      @child_resources_hash[curriculum] = Resource.new(resource_params(params))
    end

    if @resource.update_attributes(resource_params)
      @child_resources_hash.each do |curriculum, resource|
        Curriculum.create(curriculum_type: curriculum.curriculum_type, item: resource, parent: curriculum) if resource.save
      end

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

    def resource_params(ps = nil)
      ps ||= params 
      ps.
        require(:resource).
        permit(
                :description,
                :hidden,
                :resource_type,
                :short_title,
                :subtitle,
                :title,
                :url,
                additional_resource_ids: [],
                common_core_standard_ids: [],
                resource_downloads_attributes: [:_destroy, :id, :download_category_id, { download_attributes: [:description, :file, :filename_cache, :id, :title] }],
                related_resource_ids: [],
                unbounded_standard_ids: [],
                grade_list: [],
                topic_list: [],
                tag_list: [],
                resource_type_list: []
              )
    end
end
