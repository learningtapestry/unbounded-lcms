# frozen_string_literal: true

module Admin
  class MaterialsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: %i(create new)

    def index
      @query = OpenStruct.new(params[:query])
      term = identifier_term(@query)
      queryset = term ? Material.where('identifier ILIKE ?', "%#{term}%") : Material.all
      @materials = queryset.order(:identifier).paginate(page: params[:page])
    end

    def new
      @material_form = MaterialForm.new
    end

    def create
      files.each do |link|
        @material_form = MaterialForm.new({ link: link }, google_credentials)
        return render(:new, alert: t('.error')) unless @material_form.save
      end

      if files.size == 1
        redirect_to @material_form.material, notice: t('.success', name: @material_form.material.name)
      else
        redirect_to admin_materials_path, notice: t('.bulk_import', count: files.count, folder: form_params[:link])
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

    def identifier_term(query) # rubocop:disable Metrics/CyclomaticComplexity
      return unless %i(subject grade module lesson).any? { |k| query[k].present? }

      id_params = []
      id_params << query.subject&.upcase
      id_params << case query.grade
                   when 'prekindergarten' then 'PK'
                   when 'kindergarten' then 'K'
                   else
                     num = query.grade.to_s.match(/grade (\d+)/)&.[](1)
                     num.present? ? "G#{num}" : nil
                   end
      id_params << (query.module.present? ? "M#{query.module}" : nil)
      id_params << (query.lesson.present? ? "L#{query.lesson}" : nil)
      id_params.map { |param| param.presence || '%' }.join('-')
    end

    def files
      @files ||= begin
        link = form_params[:link]
        if link =~ %r{/drive/(.*/)?folders/}
          DocumentDownloader::GDoc.list_files(link, google_credentials)
        else
          [link]
        end
      end
    end
  end
end
