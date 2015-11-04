require 'content/importers/subtitles_importer'

module Unbounded
  module Admin
    class SubtitlesImportsController < AdminController
      include Content::Importers

      def index
        if ids = session[:imported_lobject_ids]
          @lobjects = Lobject.where(id: ids).includes(:lobject_titles)
        else
          redirect_to :new_unbounded_admin_subtitles_import
        end
      end

      def new
        @importer = SubtitlesImporter.new
      end

      def create
        file = params[:content_importers_subtitles_importer][:file] rescue nil
        @importer = SubtitlesImporter.new(file)
        if @importer.import
          session[:imported_lobject_ids] = @importer.lobjects.map(&:id)
          redirect_to :unbounded_admin_subtitles_imports
        else
          render :new
        end
      end
    end
  end
end
