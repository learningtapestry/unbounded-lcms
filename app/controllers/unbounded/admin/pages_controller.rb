module Unbounded
  module Admin
    class PagesController < Unbounded::AdminController
      before_action :find_resource, except: [:index, :new, :create]

      def index
        @pages = Page.order(id: :desc)
      end

      def new
        @page = Page.new
      end

      def create
        @page = Page.new(page_params)

        if @page.save
          redirect_to unbounded_page_url(@page), notice: t('.success')
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @page.update_attributes(page_params)
          redirect_to unbounded_page_url(@page), notice: t('.success')
        else
          render :edit
        end
      end

      def destroy
        @page.destroy
        redirect_to :unbounded_admin_pages, notice: t('.success')
      end

      private
        def find_resource
          @page = Page.find(params[:id])
        end

        def page_params
          params.require(:content_models_page).permit(:body, :title, :slug)
        end
    end
  end
end
