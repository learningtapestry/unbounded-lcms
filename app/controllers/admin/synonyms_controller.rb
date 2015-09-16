module Admin
  class SynonymsController < AdminController
    before_action :find_synonyms

    def edit
    end

    def update
      new_synonyms = params[:synonyms].split(/[\r\n]+/)
      Lobject.update_index_synonyms(new_synonyms)
      redirect_to admin_edit_synonyms_path, notice: t('.success')
    end

    protected

    def find_synonyms
      @synonyms = Lobject.get_index_synonyms
    end
  end
end
