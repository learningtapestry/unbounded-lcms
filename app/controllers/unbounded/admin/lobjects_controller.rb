module Unbounded
  module Admin
    class LobjectsController < Unbounded::AdminController
      before_action :find_resource, except: [:new, :create]

      def new
        @lobject = Lobject.new(organization: Organization.unbounded)
        @lobject.lobject_descriptions.new
        @lobject.lobject_languages.new
        @lobject.lobject_titles.new
        @lobject.lobject_urls.new(url: Url.new)
      end

      def create
        @lobject = Organization.unbounded.lobjects.new(lobject_params)

        if @lobject.save
          redirect_to unbounded_show_url(@lobject)
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @lobject.update_attributes(lobject_params)
          redirect_to unbounded_show_url(@lobject)
        else
          render :edit
        end
      end

      def destroy
        @lobject.destroy
        redirect_to :unbounded, notice: t('.success', lobject_id: @lobject.id)
      end

      private
        def find_resource
          @lobject = Organization.unbounded.lobjects.find(params[:id])
        end

        def lobject_params
          params.
            require(:content_models_lobject).
            permit(
                    alignment_ids: [],
                    grade_ids: [],
                    lobject_descriptions_attributes: [:description, :id],
                    lobject_downloads_attributes: [:_destroy, :id, { download_attributes: [:description, :file, :filename_cache, :id, :title] }],
                    lobject_languages_attributes: [:id, :language_id],
                    lobject_titles_attributes: [:id, :title],
                    lobject_urls_attributes: [:id, { url_attributes: [:id, :url] }],
                    related_lobject_ids: [],
                    resource_type_ids: [],
                    subject_ids: [],
                    topic_ids: []
                  )
        end
    end
  end
end
