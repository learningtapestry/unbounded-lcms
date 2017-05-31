module Admin
  class CurriculumTreesController < AdminController
    before_action :set_form, only: %i(edit update)

    def index
      @curriculum_trees = CurriculumTree.order(default: :desc).paginate(page: params[:page])
    end

    def edit
      @curriculum_tree = @form.presenter
    end

    def update
      if @form.save
        redirect_to admin_curriculum_trees_path,
                    notice: t('.success')
      else
        @curriculum_tree = @form.presenter
        render :edit, alert: t('.error')
      end
    end

    private

    def set_form
      @form = CurriculumTreeForm.new(params[:id], params[:curriculum_tree])
    end
  end
end
