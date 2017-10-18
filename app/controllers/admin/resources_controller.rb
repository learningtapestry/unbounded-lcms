module Admin
  class ResourcesController < AdminController
    CREATE_TAG_KEYS = %i(new_topic_names new_tag_names new_content_source_names
                         new_unbounded_standard_names).freeze
    CREATE_TAG_METHODS = {
      new_topic_names: 'topic',
      new_tag_names: 'tag',
      new_content_source_names: 'content_source'
    }.freeze

    before_action :find_resource, except: %i(index new create)

    def index
      @query = Resource.ransack(params[:q].try(:except, :grades))
      resources = @query.result.includes(:standards, :taggings)
      resources = resources.where_curriculum(grade_params) if grade_params.present?
      @resources = resources.order(id: :desc).paginate(page: params[:page], per_page: 15)
    end

    def new
      @resource = Resource.new
    end

    def create
      @resource = Resource.new(resource_params)

      if @resource.save
        create_tags
        redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
      else
        render :new
      end
    end

    def edit; end

    def update
      return redirect_to :admin_resources, alert: t('admin.common.editing_disabled') unless Settings.editing_enabled?

      create_tags
      Array.wrap(create_params[:new_unbounded_standard_names]).each do |std_name|
        std = UnboundedStandard.create_with(subject: @resource.subject).find_or_create_by!(name: std_name)
        resource_params[:unbounded_standard_ids] << std.id
      end

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

    def grade_params
      params.fetch(:q, {}).fetch(:grades, []).select(&:present?)
    end

    def form_params
      @ps ||= begin
        ps = params.require(:resource).permit(
          :curriculum_type,
          :curriculum_directory,
          :parent_id,
          :tree,
          :description,
          :hidden,
          :resource_type,
          :short_title,
          :subtitle,
          :title,
          :teaser,
          :url,
          :time_to_teach,
          :ell_appropriate,
          :image_file,
          :opr_description,
          additional_resource_ids: [],
          common_core_standard_ids: [],
          resource_downloads_attributes: [
            :_destroy,
            :id,
            :download_category_id, { download_attributes: %i(description file main filename_cache id title) }
          ],
          related_resource_ids: [],
          unbounded_standard_ids: [],
          new_unbounded_standard_names: [],
          topic_ids: [],
          tag_ids: [],
          content_source_ids: [],
          reading_assignment_text_ids: [],
          new_topic_names: [],
          new_tag_names: [],
          new_content_source_names: []
        )
        ps[:curriculum_directory] = ps[:curriculum_directory].split(',')
        ps
      end
    end

    def resource_params
      @rp ||= form_params.except(*CREATE_TAG_KEYS)
    end

    def create_params
      @cp ||= form_params.slice(*CREATE_TAG_KEYS)
    end

    def create_tags
      CREATE_TAG_METHODS.each do |params_key, basename|
        Array.wrap(create_params[params_key]).each do |name|
          @resource.send("#{basename}_list").push(name) if name.present?
        end
      end
    end
  end
end
