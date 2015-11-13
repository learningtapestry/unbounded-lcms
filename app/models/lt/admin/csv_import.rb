require 'content/importers/csv_importer'
require 'securerandom'

module Lt
  module Admin
    class CsvImport
      include ActiveModel::Model
      include Content::Importers

      attr_accessor :file, :replace

      validates :file, presence: true
      validate :csv_format

      def import
        if valid?
          CsvImportJob.perform_later(copy_file, replace)
        end
      end

      def csv_format
        if file && !CsvImporter.check_csv(file.path)
          errors.add(:file, :incorrect_format, headers: CsvImporter::HEADERS)
        end
      end

      def copy_file
        basename = Rails.public_path.join('uploads', 'lt', 'admin', 'csv_imports')
        path = basename.join("#{SecureRandom.uuid}_#{file.original_filename}")
        FileUtils.mkdir_p(basename); FileUtils.cp(file.path, path)
        path.to_s
      end
    end
  end
end
