module Admin
  class ResourcesController < AdminController
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
      rp = resource_params
      cp = create_params(rp)

      @resource = Resource.new(rp.except(:tree))
      @resource.curriculum_tree_id = rp[:tree] == '1' ? CurriculumTree.default.id : nil

      if @resource.save
        tag_creation = [
          [:new_topic_names, 'topic'],
          [:new_tag_names, 'tag'],
          [:new_content_source_names, 'content_source']
        ]

        tag_creation.each do |(params_key, basename)|
          Array.wrap(cp[params_key]).each { |name| @resource.send("#{basename}_list").push(name) if name.present? }
        end

        redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
      else
        render :new
      end
    end

    def edit; end

    def update
      return redirect_to :admin_resources, alert: t('admin.common.editing_disabled') unless Settings.editing_enabled?

      rp = resource_params
      cp = create_params(rp)

      tag_creation = [
        [:new_topic_names, 'topic'],
        [:new_tag_names, 'tag'],
        [:new_content_source_names, 'content_source']
      ]

      tag_creation.each do |(params_key, basename)|
        Array.wrap(cp[params_key]).each { |name| @resource.send("#{basename}_list").push(name) if name.present? }
      end

      Array.wrap(cp[:new_unbounded_standard_names]).each do |std_name|
        std = UnboundedStandard.create_with(subject: @resource.subject).find_or_create_by!(name: std_name)
        rp[:unbounded_standard_ids] << std.id
      end

      @resource.curriculum_tree_id = rp[:tree] == '1' ? CurriculumTree.default.id : nil

      if @resource.update_attributes(rp.except(:tree))
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

    def resource_params(ps = nil)
      ps ||= params
      ps = ps.require(:resource)
             .permit(
               :curriculum_type,
               :curriculum_directory,
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

    def create_params(rp)
      cparams = {}

      %i(new_topic_names new_tag_names new_content_source_names new_unbounded_standard_names)
        .each { |p| cparams[p] = rp.delete(p) }

      cparams
    end
  end
end
