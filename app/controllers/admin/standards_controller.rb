class Admin::StandardsController < Admin::AdminController
  before_action :find_standard, except: [:index]

  def index
    @standards = Standard.order(id: :desc).paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @standard.update_attributes(standard_params)
      redirect_to admin_standards_path, notice: t('.success')
    else
      render :edit
    end
  end

  private
    def find_standard
      @standard = Standard.find(params[:id])
    end

    def standard_params
      params.require(:standard).permit(:note, :description, :file)
    end
end
