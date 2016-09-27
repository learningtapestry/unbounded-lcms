module Admin
  class ContentGuidesController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: :import
    before_action :load_content_guide, only: %i(edit update)

    def index
      @content_guides = ContentGuide.sort_by_grade
    end

    def reset_pdfs
      ContentGuide.find_each do |cg|
        cg.remove_pdf!
        cg.save!
      end
      redirect_to({ action: :index }, notice: 'Cached PDFs were reset')
    rescue Excon::Errors::Error => e
      redirect_to({ action: :index }, alert: e.to_s)
    end

    def edit
      @content_guide.validate_metadata
    end

    def update
      content_guide_params = params.require(:content_guide).permit(:date, :description, :slug, :subject, :teaser, :title, :update_metadata, common_core_standard_ids: [], grade_list: [], unbounded_standard_ids: [])

      if @content_guide.update(content_guide_params)
        redirect_to :admin_content_guides, notice: t('.success', name: @content_guide.name)
      else
        render :edit
      end
    end

    def destroy
      content_guide = ContentGuide.find(params[:id])
      content_guide.destroy
      redirect_to :admin_content_guides, notice: t('.success', name: content_guide.name)
    end

    # GET /content_guides/import
    def import
      file_id = ContentGuide.file_id_from_url(params[:content_guide][:url])
      redirect_to(:new_admin_content_guide, alert: 'Incorrect link!') and return if file_id.blank?

      @content_guide = ContentGuide.import(file_id, google_credentials)
      if @content_guide.errors.empty?
        redirect_to [:edit, :admin, @content_guide], notice: t('.success', name: @content_guide.name)
      end
    end

    # GET /content_guides/links_validation
    def links_validation
      @content_guides = ContentGuide.all.map { |d| ContentGuidePresenter.new(d, request.base_url, view_context) }
    end

    private

    def load_content_guide
      @content_guide = ContentGuide.find(params[:id])
    end
  end
end
