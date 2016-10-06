class Admin::DownloadCategoriesController < Admin::AdminController
  before_action :find_download_category, except: [:index, :new, :create]

  def create
    @category = DownloadCategory.new(download_category_params)
    if @category.save
      redirect_to :admin_download_categories, notice: t('.success')
    else
      render :new
    end
  end

  def destroy
    @category.destroy
    redirect_to :admin_download_categories, notice: t('.success')
  end

  def index
    @categories = DownloadCategory.all
  end

  def edit
  end

  def new
    @category = DownloadCategory.new
  end

  def update
    if @category.update_attributes(download_category_params)
      edit_path = edit_admin_download_category_path(@category)
      redirect_to edit_path, notice: t('.success')
    else
      render :edit
    end
  end

  private

    def find_download_category
      @category = DownloadCategory.find(params[:id])
    end

    def download_category_params
      params.require(:download_category).permit( :name, :description)
    end

end
