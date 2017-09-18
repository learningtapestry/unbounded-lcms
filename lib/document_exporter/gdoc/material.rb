# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    class Material < Gdoc::Base
      def export
        @options[:subfolders] = [DocumentExporter::Gdoc::StudentMaterial::FOLDER_NAME] if student?
        @options[:subfolders] = [DocumentExporter::Gdoc::TeacherMaterial::FOLDER_NAME] if teacher?
        unless @options.key?(:subfolders)
          Rails.logger.warn "Material belongs neither to teachers nor to students: #{document.id}"
          @options[:subfolders] = ['Materials']
        end

        handle_vertical_text if document.vertical_text?

        super
      end

      private

      def handle_vertical_text
        data = TextToImage.new(document.metadata.vertical_text, rotate: -90).raw
        filename = "#{document.base_filename}-vtext"

        metadata = {
          name: filename,
          mime_type: 'image/png'
        }

        params = {
          content_type: 'image/png',
          upload_source: StringIO.new(data)
        }

        file_id = if (id = drive_service.file_exists?(filename, drive_service.parent))
                    drive_service.service.update_file(id, Google::Apis::DriveV3::File.new(metadata), params)
                  else
                    metadata[:parents] = [drive_service.parent]
                    drive_service.service.create_file(Google::Apis::DriveV3::File.new(metadata), params)
                  end.id

        @options[:vertical_text_image_url] = "https://drive.google.com/uc?id=#{file_id}"
      end

      def student?
        ::Material.where(id: document.id).where_metadata_any_of(config_for(:student)).present?
      end

      def teacher?
        ::Material.where(id: document.id).where_metadata_any_of(config_for(:teacher)).present?
      end

      def template_path(name)
        File.join('documents', 'gdoc', 'materials', name)
      end

      def vertical_text_image_data
        TextToImage.new(document.metadata.vertical_text, rotate: -90).raw
      end
    end
  end
end
