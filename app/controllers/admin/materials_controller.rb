# frozen_string_literal: true

module Admin
  class MaterialsController < AdminController
    include GoogleAuth

    before_action :google_authorization, only: %i(create new reimport_selected)
    before_action :find_selected, only: %i(destroy_selected reimport_selected)

    def index
      @query = OpenStruct.new(params[:query])
      @materials = materials(@query)
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
      material = Material.find(params[:id])
      material.destroy
      redirect_to admin_materials_path(query: params[:query]), notice: t('.success')
    end

    def destroy_selected
      count = @materials.destroy_all.count
      redirect_to admin_materials_path(query: params[:query]), notice: t('.success', count: count)
    end

    def new
      @results = []
      @material_form = MaterialForm.new
    end

    def reimport_selected
      @results = []
      @materials.each do |material|
        link = material.file_url
        form = MaterialForm.new({ link: link }, google_credentials)
        res = if form.save
                OpenStruct.new(ok: true, link: link, material: form.material)
              else
                OpenStruct.new(ok: false, link: link, errors: form.errors[:link])
              end
        @results << res
      end
      msg = render_to_string(partial: 'admin/materials/import_results', layout: false, locals: { results: @results })
      redirect_to admin_materials_path(query: params[:query]), notice: msg
    end

    private

    def find_selected
      return head(:bad_request) unless params[:selected_ids].present?

      ids = params[:selected_ids].split(',')
      @materials = Material.where(id: ids)
    end

    def form_params
      params.require(:material_form).permit(:link)
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

    def google_authorization
      options = {}
      if action_name == 'reimport_selected'
        return_path = admin_materials_path(query: params[:query], selected_ids: params[:selected_ids])
        options[:redirect_to] = return_path
      end
      obtain_google_credentials options
    end

    def materials(q)
      qset = Material.order(:identifier)
      qset = qset.search_identifier(q.search_term) if q.search_term.present?

      %i(type sheet_type breadcrumb_level subject).each do |key|
        qset = qset.where_metadata_like(key, q[key]) if q[key].present?
      end

      %i(grade module unit lesson).each do |key|
        qset = qset.joins(:documents).where('documents.metadata @> hstore(?, ?)', key, q[key]) if q[key].present?
      end

      qset.paginate(page: params[:page])
    end
  end
end
