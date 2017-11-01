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
      return bulk_import(gdoc_files) && render(:import) if gdoc_files.size > 1

      @material_form = MaterialForm.new(form_params, google_credentials)
      if @material_form.save
        material = @material_form.material
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

    def import_status
      jid = params[:jid]
      data = { status: MaterialParseJob.status(jid) }
      data[:result] = MaterialParseJob.fetch_result(jid) if data[:status] == :done
      render json: data, status: :ok
    end

    def new
      @material_form = MaterialForm.new(source_type: params[:source_type].presence || 'gdoc')
    end

    def reimport_selected
      bulk_import @materials.map(&:file_url)
      render :import
    end

    private

    def bulk_import(files)
      jobs = {}
      google_auth_id = GoogleAuthService.new(self).user_id
      files.each do |url|
        job_id = MaterialParseJob.perform_later(url, google_auth_id).job_id
        jobs[job_id] = { link: url, status: 'waiting' }
      end
      @props = { jobs: jobs, type: :materials }
    end

    def find_selected
      return head(:bad_request) unless params[:selected_ids].present?

      ids = params[:selected_ids].split(',')
      @materials = Material.where(id: ids)
    end

    def form_params
      params.require(:material_form).permit(:link, :source_type)
    end

    def gdoc_files
      @gdoc_files ||= begin
        link = form_params[:link]
        return [link] unless link =~ %r{/drive/(.*/)?folders/}
        if form_params[:source_type] == 'pdf'
          DocumentDownloader::PDF.list_files(link, google_credentials)
        else
          DocumentDownloader::Gdoc.list_files(link, google_credentials)
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
      qset = Material.all
      qset = qset.search_identifier(q.search_term) if q.search_term.present?

      if q[:source].present?
        qset = q[:source] == 'pdf' ? qset.pdf : qset.gdoc
      end

      %i(type sheet_type breadcrumb_level subject).each do |key|
        qset = qset.where_metadata_like(key, q[key]) if q[key].present?
      end

      %i(grade module unit lesson).each do |key|
        qset = qset.joins(:documents).where('documents.metadata @> hstore(?, ?)', key, q[key]) if q[key].present?
      end

      qset = qset.order(:identifier) if q.sort_by.blank? || q.sort_by == 'identifier'
      qset = qset.order(updated_at: :desc) if q.sort_by == 'last_update'

      qset.paginate(page: params[:page])
    end
  end
end
