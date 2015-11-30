require 'content/importers/csv_importer'

module Lt
  module Admin
    class CsvImportsController < AdminController
      include Content::Importers

      def new
        @csv_import = CsvImport.new
        @export_in_progress = export_in_progress?
      end

      def create
        @csv_import = CsvImport.new(csv_import_params)
        if @csv_import.import
          redirect_to :new_lt_admin_csv_import, notice: t('.success')
        else
          render :new
        end
      end

      def export
        latest = Dir["#{csv_export_folder}/*"].sort { |a,b| File.mtime(a) <=> File.mtime(b) }.last
        send_file(latest, filename: File.basename(latest), type: 'text/csv')
      end

      def create_export
        CsvExportJob.perform_later(csv_export_path)
        redirect_to :new_lt_admin_csv_import, notice: t('.success')
      end

      protected

      def csv_import_params
        params.require(:lt_admin_csv_import).permit(:file, :replace)
      end

      def csv_export_folder
        basename = Rails.public_path.join('csv_exports'); FileUtils.mkdir_p(basename.to_s)
        basename
      end

      def csv_export_path
        uuid = SecureRandom.uuid
        date = Time.now.strftime("%Y-%m-%d")
        csv_export_folder.join("ContentExport_#{date}_#{uuid}.csv").to_s
      end

      def export_in_progress?
        Delayed::Job.all.any? { |dj| dj.handler.include? 'CsvExportJob' }
      end
    end
  end
end
