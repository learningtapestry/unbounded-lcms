class Admin::ResourceBulkEditsController < Admin::AdminController
  before_action :load_resources

  def new
    if @resources.any?
      @resource = Resource.init_for_bulk_edit(@resources)
    else
      redirect_to :admin_resources, alert: t('.no_resources')
    end
  end

  def create
    resource_params = params.require(:resource).permit(
      standard_ids: [],
      grades_list: [],
      resource_types_list: [],
      tags_list: []
    )
    sample = Resource.new(resource_params)
    Resource.bulk_edit(sample, @resources)
    redirect_to :admin_resources, notice: t('.success',
      count: @resources.count,
      resources_count: t(:resources_count, count: @resources.count)
    )
  end

  private
    def load_resources
      @resources = Resource.where(id: params[:ids])
      .includes(:standards, :taggings)
    end
end
