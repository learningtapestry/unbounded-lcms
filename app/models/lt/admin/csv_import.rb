module Lt
  module Admin
    class CsvImport
      extend CarrierWave::Mount
      mount_uploader :file, CsvImportUploader

      def self.store_file(file)
        csv_import = CsvImport.new
        csv_import.file = file
        csv_import.store_file! && csv_import.file
      end
    end
  end
end
