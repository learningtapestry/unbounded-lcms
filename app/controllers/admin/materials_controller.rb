# frozen_string_literal: true

module Admin
  class MaterialsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: %i(create new)

    def index
      @query = OpenStruct.new(params[:query])
      term = identifier_term(@query)
      queryset = term ? Material.search_identifier(term) : Material.all
      @materials = queryset.order(:identifier).paginate(page: params[:page])
    end

    def new
      @results = []
      @material_form = MaterialForm.new
    end

    def create
      @results = []
      @material_form = MaterialForm.new(form_params)
      files.each do |link|
        form = MaterialForm.new({ link: link }, google_credentials)
        res = if form.save
                OpenStruct.new(ok: true, link: link, material: form.material)
              else
                OpenStruct.new(ok: false, link: link, errors: form.errors[:link])
              end
        @results << res
      end

      if files.size == 1 && @results.first.ok
        material = @results.first.material
        redirect_to material, notice: t('.success', name: material.name)
      else
        render :new
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

    def identifier_term(query)
      return unless %i(search_term subject grade module lesson).any? { |k| query[k].present? }

      id_params = []
      id_params << query.subject
      id_params << case query.grade
                   when 'prekindergarten' then 'PK'
                   when 'kindergarten' then 'K'
                   else
                     num = query.grade.to_s.match(/grade (\d+)/)&.[](1)
                     num.present? ? "G#{num}" : nil
                   end
      id_params << (query.module.present? ? "M#{query.module}" : nil)
      id_params << (query.lesson.present? ? "L#{query.lesson}" : nil)
      id_params << query.search_term
      id_params.select(&:present?).uniq.join(' ')
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
