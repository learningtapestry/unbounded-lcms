module Admin
  class ContentGuideFaqsController < AdminController
    before_action :load_resource, only: [:edit, :update, :destroy]

    def index
      @content_guide_faqs = ContentGuideFaq.all
    end

    def new
      @content_guide_faq = ContentGuideFaq.new
    end

    def create
      @content_guide_faq = ContentGuideFaq.new(content_guide_faq_params)

      if @content_guide_faq.save
        redirect_to :admin_content_guide_faqs, notice: t('.success')
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @content_guide_faq.update_attributes(content_guide_faq_params)
        redirect_to :admin_content_guide_faqs, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      @content_guide_faq.destroy
      redirect_to :admin_content_guide_faqs, notice: t('.success')
    end

    private

    def load_resource
      @content_guide_faq = ContentGuideFaq.find(params[:id])
    end

    def content_guide_faq_params
      params.require(:content_guide_faq)
            .permit(:title, :subject, :active, :description, :heading, :subheading)
    end
  end
end
