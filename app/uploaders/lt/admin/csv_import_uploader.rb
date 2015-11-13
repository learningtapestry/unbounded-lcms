module Lt
  module Admin
    class CsvImportUploader < CarrierWave::Uploader::Base
      storage :file

      def extension_white_list
        ['csv']
      end

      def filename
        "#{file.basename}_#{Time.now.to_i}.#{file.extension}"
      end

      def store_dir
        "uploads/csv_imports"
      end

      def full_path
        Rails.public_path.join(path).to_s
      end
    end
  end
end
