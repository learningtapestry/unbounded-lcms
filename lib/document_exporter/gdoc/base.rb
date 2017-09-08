# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'google/apis/script_v1'

module DocumentExporter
  module Gdoc
    class Base < DocumentExporter::Base
      VERSION_RE = /_v\d+$/i

      attr_reader :document, :options

      def self.gdoc_key(type)
        "gdoc_#{type}"
      end

      def self.url_for(file_id)
        "https://drive.google.com/open?id=#{file_id}"
      end

      def create_gdoc_folders(folder)
        id = drive_service.create_folder(folder)
        drive_service.create_folder(DocumentExporter::Gdoc::TeacherMaterial::FOLDER_NAME, id)
        drive_service.create_folder(DocumentExporter::Gdoc::StudentMaterial::FOLDER_NAME, id)
      end

      def export
        parent_folder = drive_service.file_id.blank? ? drive_service.parent : nil

        file_params = { name: document.base_filename, mime_type: 'application/vnd.google-apps.document' }
        file_params[:parents] = [parent_folder] if parent_folder.present?
        metadata = Google::Apis::DriveV3::File.new(file_params)

        params = {
          content_type: 'text/html',
          upload_source: StringIO.new(content)
        }

        delete_previous_versions_from(parent_folder) if parent_folder

        @id = if drive_service.file_id.blank?
                drive_service.service.create_file(metadata, params)
              else
                drive_service.service.update_file(drive_service.file_id, metadata, params)
              end.id

        post_processing

        self
      end

      def url
        self.class.url_for @id
      end

      private

      def base_path(name)
        File.join('documents', 'gdoc', name)
      end

      def content
        render_template template_path('show'), layout: 'ld_gdoc'
      end

      #
      # Deletes files of previous versions
      #
      def delete_previous_versions_from(folder)
        drive_service.service.list_files(q: "'#{folder}' in parents").files.each do |file|
          next unless file.name =~ VERSION_RE
          drive_service.service.delete_file file.id
        end
      end

      def drive_service
        @drive_service ||= GoogleApi::DriveService.build(Google::Apis::DriveV3::DriveService, document, options)
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
