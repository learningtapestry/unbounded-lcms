require 'content/importers/csv_importer'

module Lt
  module Admin
    class ImportController < AdminController
      def index
      end

      def import_csv
        file = CsvImport.store_file(params.required('file'))
        if file && Content::Importers::CsvImporter.check_csv(file.full_path)
          CsvImportJob.perform_later(file.full_path, !!params['replace'])
          flash[:notice] = t('.success')
        else
          flash[:notice] = t('.fail_csv')
        end
        redirect_to :lt_admin_import
      end

      def export
        headers['X-Accel-Buffering'] = 'no'
        headers["Cache-Control"] ||= "no-cache"
        headers["Content-Type"] = "text/csv"
        headers["Content-disposition"] = "attachment; filename=Content-#{Time.now.strftime("%Y-%m-%d")}.csv"
        headers.delete("Content-Length")
        response.status = 200
        self.response_body = Content::Importers::CsvImporter::Exporter.new
      end
    end
  end
end
