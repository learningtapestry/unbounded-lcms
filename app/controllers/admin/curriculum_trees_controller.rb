module Admin
  class CurriculumTreesController < AdminController
    def index
      @curriculums = CurriculumTree
                       .order(default: :desc)
                       .paginate(page: params[:page])
    end

    def edit
      @curriculum = CurriculumTree.find(params[:id]).presenter
    end

    def update
      @curriculum = CurriculumTreeForm.new(params[:id],
                                           params[:curriculum_tree])
      if @curriculum.save
        redirect_to admin_curriculum_trees_path,
                    notice: t('.success')
      else
        render :edit, alert: t('.error')
      end
    end
  end
end
