require 'content/importers/csv_importer'
require 'securerandom'

module Lt
  module Admin
    class CsvImport
      UPLOAD_PATH = Rails.public_path.join('uploads', 'lt', 'admin', 'csv_imports')

      include ActiveModel::Model
      include Content::Importers

      attr_accessor :file, :replace

      validates :file, presence: true
      validate :csv_format

      def import
        if valid?
          CsvImportJob.perform_later(copy_file, replace?)
        end
      end

      def csv_format
        if file && !CsvImporter.check_csv(file.path)
          errors.add(:file, :incorrect_format, headers: CsvImporter::HEADERS)
        end
      end

      def copy_file
        FileUtils.mkdir_p(UPLOAD_PATH)

        path = UPLOAD_PATH.join("#{SecureRandom.uuid}_#{file.original_filename}").to_s
        FileUtils.cp(file.path, path) ; File.chmod(0644, path)
        path
      end

      def replace?
        replace.to_i == 1
      end
    end
  end
end
