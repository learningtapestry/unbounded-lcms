# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    Base.module_eval do
      def drive_service
        @drive_service ||= GoogleApi::DriveService.build(Google::Apis::DriveV3::DriveService,
                                                         document,
                                                         options)
      end

      def gdoc_folder
        @options[:subfolders] = [self.class::FOLDER_NAME] if defined?(self.class::FOLDER_NAME)
        @id = GoogleApi::DriveService
                .build_with(drive_service.service, document, options)
                .parent
        self
      end

      def gdoc_folder_tmp(material_ids)
        file_ids = material_ids.map do |id|
          document.links['materials']&.dig(id.to_s)&.dig('gdoc')&.gsub(/.*id=/, '')
        end

        @options[:subfolders] = [self.class::FOLDER_NAME]
        @id = GoogleApi::DriveService
                .build_with(drive_service.service, document, options)
                .copy(file_ids)
        self
      end

      def post_processing
        GoogleApi::ScriptService
          .build(Google::Apis::ScriptV1::ScriptService, document)
          .execute(@id)
      end
    end
  end
end