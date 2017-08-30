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

      def export
        file_service = GoogleApi::DriveService.new(service, document, options)

        parent_folder = file_service.file_id.blank? ? file_service.parent : nil

        file_params = { name: document.base_filename, mime_type: 'application/vnd.google-apps.document' }
        file_params[:parents] = [parent_folder] if parent_folder.present?
        metadata = Google::Apis::DriveV3::File.new(file_params)

        params = {
          content_type: 'text/html',
          upload_source: StringIO.new(content)
        }

        delete_previous_versions_from(parent_folder) if parent_folder

        @id = if file_service.file_id.blank?
                service.create_file(metadata, params)
              else
                service.update_file(file_service.file_id, metadata, params)
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

      def credentials
        @credentials ||= GoogleApi::AuthCLIService.new.credentials
      end

      #
      # Deletes files of previous versions
      #
      def delete_previous_versions_from(folder)
        service.list_files(q: "'#{folder}' in parents").files.each do |file|
          next unless file.name =~ VERSION_RE
          service.delete_file file.id
        end
      end

      def gdoc_folder
        @options[:subfolders] = [self.class::FOLDER_NAME] if defined?(self.class::FOLDER_NAME)
        file_service = GoogleApi::DriveService.new(service, document, options)
        @id = file_service.parent
        self
      end

      def gdoc_folder_tmp(material_ids)
        @options[:subfolders] = [self.class::FOLDER_NAME]
        file_service = GoogleApi::DriveService.new(service, document, options)

        file_ids = material_ids.map do |id|
          document.links['materials']&.dig(id.to_s)&.dig('gdoc')&.gsub(/.*id=/, '')
        end

        @id = file_service.copy(file_ids)
        self
      end

      def post_processing
        GoogleApi::ScriptService.new(script_service, document).execute(@id)
      end

      def service
        return @_service if @_service.present?
        @_service = Google::Apis::DriveV3::DriveService.new
        @_service.authorization = credentials
        @_service
      end

      def script_service
        return @_script_service if @_script_service.present?
        @_script_service = Google::Apis::ScriptV1::ScriptService.new
        @_script_service.authorization = credentials
        @_script_service
      end
    end
  end
end
