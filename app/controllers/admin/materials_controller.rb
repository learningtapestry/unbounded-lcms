module Admin
  class MaterialsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: %i(create new)

    def index
      @materials = Material.order(:identifier).paginate(page: params[:page])
    end

    def new
      @material_form = MaterialForm.new
    end

    def create
      @material_form = MaterialForm.new form_params, google_credentials
      if @material_form.save
        redirect_to @material_form.material, notice: t('.success', name: @material_form.material.name)
      else
        render :new, alert: t('.error')
      end
    end

    def destroy
      @material = Material.find(params[:id])
      @material.destroy
      redirect_to :admin_documents, notice: t('.success')
    end

    private

    def form_params
      params.require(:material_form).permit(:link)
    end
  end
end
