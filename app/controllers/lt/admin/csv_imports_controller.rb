require 'content/importers/csv_importer'

module Lt
  module Admin
    class CsvImportsController < AdminController
      include Content::Importers

      def new
        @csv_import = CsvImport.new
      end

      def create
        @csv_import = CsvImport.new(csv_import_params)
        if @csv_import.import
          flash[:notice] = t('.success')
          redirect_to :new_lt_admin_csv_import
        else
          render :new
        end
      end

      def export
        headers['X-Accel-Buffering'] = 'no'
        headers["Cache-Control"] ||= "no-cache"
        headers["Content-Type"] = "text/csv"
        headers["Content-disposition"] = "attachment; filename=Content-#{Time.now.strftime("%Y-%m-%d")}.csv"
        headers.delete("Content-Length")
        response.status = 200
        self.response_body = CsvImporter::Exporter.new
      end

      protected

      def csv_import_params
        params.require(:lt_admin_csv_import).permit(:file, :replace)
      end
    end
  end
end
