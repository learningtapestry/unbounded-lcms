module Admin
  class StandardsController < Admin::AdminController
    before_action :find_standard, except: [:index]

    def index
      @query = OpenStruct.new params[:query]

      scope = Standard.order(:id)
      scope = Standard.bilingual if @query.is_language_progression_standard == '1'
      scope = scope.search_by_name(@query.name) if @query.name.present?

      @standards = scope.paginate(page: params[:page])
    end

    def update
      if @standard.update(standard_params)
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
      @std_params ||= params.require(:standard).permit(
        :description,
        :language_progression_note,
        :language_progression_file,
        :language_progression_file_cache,
        :remove_language_progression_file
      ).tap do |whitelist|
        ps = params[:standard]

        whitelist[:is_language_progression_standard] = true if ps[:language_progression_file].present?
        whitelist[:is_language_progression_standard] = false if ps[:remove_language_progression_file] == '1'
      end
    end
  end
end
