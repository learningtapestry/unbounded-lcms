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
    @parent_curriculum = if params[:curriculum_id].present?
      Curriculum.find(params[:curriculum_id])
    end
    @resource = Resource.new
  end

  def create
    rp = resource_params
    cp = create_params(rp)

    @parent_curriculum = if rp.has_key?(:curriculum_id)
      Curriculum.find(rp.delete(:curriculum_id))
    end

    @resource = Resource.new(rp)

    if @resource.save
      tag_creation = [
        [:new_grade_names, 'grade'],
        [:new_topic_names, 'topic'],
        [:new_tag_names, 'tag'],
        [:new_content_source_names, 'content_source']
      ]

      tag_creation.each do |(params_key, basename)|
        Array.wrap(cp[params_key]).each do |name|
          next if name.blank?
          @resource.send("#{basename}_list").push(name)
        end
      end

      @parent_curriculum.add_child(@resource) if @parent_curriculum
      redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    unless Settings.editing_enabled?
      redirect_to :admin_resources, alert: t('admin.common.editing_disabled')
      return
    end

    rp = resource_params
    cp = create_params(rp)

    tag_creation = [
      [:new_grade_names, 'grade'],
      [:new_topic_names, 'topic'],
      [:new_tag_names, 'tag'],
      [:new_content_source_names, 'content_source']
    ]

    tag_creation.each do |(params_key, basename)|
      Array.wrap(cp[params_key]).each do |name|
        next if name.blank?
        @resource.send("#{basename}_list").push(name)
      end
    end

    Array.wrap(cp[:new_unbounded_standard_names]).each do |std_name|
      std = UnboundedStandard
        .create_with(subject: @resource.subject)
        .find_or_create_by!(name: std_name)
      rp[:unbounded_standard_ids] << std.id
    end

    if @resource.update_attributes(rp)
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
                :curriculum_id,
                :description,
                :hidden,
                :resource_type,
                :short_title,
                :subtitle,
                :title,
                :teaser,
                :url,
                :time_to_teach,
                :subject,
                :ell_appropriate,
                :image_file,
                additional_resource_ids: [],
                common_core_standard_ids: [],
                resource_downloads_attributes: [:_destroy, :id, :download_category_id, { download_attributes: [:description, :file, :filename_cache, :id, :title] }],
                related_resource_ids: [],
                unbounded_standard_ids: [],
                new_unbounded_standard_names: [],
                grade_ids: [],
                topic_ids: [],
                tag_ids: [],
                content_source_ids: [],
                reading_assignment_text_ids: [],
                new_grade_names: [],
                new_topic_names: [],
                new_tag_names: [],
                new_content_source_names: []
              )
    end

    def create_params(rp)
      cparams = {}

      [
        :new_grade_names,
        :new_topic_names,
        :new_tag_names,
        :new_content_source_names,
        :new_unbounded_standard_names
      ].each { |p| cparams[p] = rp.delete(p) }

      cparams
    end
end
