# frozen_string_literal: true

module GoogleApi
  class DriveService < Base
    FOLDER_ID   = ENV['GOOGLE_APPLICATION_FOLDER_ID']
    MIME_FOLDER = 'application/vnd.google-apps.folder'
    MIME_FILE   = 'application/vnd.google-apps.document'

    def copy(file_ids)
      folder_id = parent
      file_ids.each do |id|
        service.update_file(id,
                            add_parents: folder_id,
                            fields: 'id, parents')
      end
      folder_id
    end

    def file_id
      @file_id ||= begin
        file_name = document.base_filename
        response = service.list_files(
          q: "'#{parent}' in parents and name = '#{file_name}' and mimeType = '#{MIME_FILE}' and trashed = false",
          fields: 'files(id)'
        )
        return nil if response.files.empty?
        unless response.files.size == 1
          Rails.logger.warn "Multiple files: more than 1 file with same name: #{file_name}"
        end
        response.files[0].id
      end
    end

    def parent
      @parent ||=
        begin
          subfolders = (options[:subfolders] || []).unshift(options[:gdoc_folder] || document.gdoc_folder)
          parent_folder = FOLDER_ID
          subfolders.each do |folder|
            parent_folder = subfolder(folder, parent_folder)
          end
          parent_folder
        end
    end

    private

    def create_folder(folder, parent_folder = FOLDER_ID)
      metadata = Google::Apis::DriveV3::File.new(
        name: folder,
        mime_type: 'application/vnd.google-apps.folder',
        parents: [parent_folder]
      )
      service.create_file(metadata).id
    end

    def subfolder(folder, parent_folder = FOLDER_ID)
      response = service.list_files(
        q: "'#{parent_folder}' in parents and name = '#{folder}' and mimeType = '#{MIME_FOLDER}' and trashed = false",
        fields: 'files(id)'
      )
      return create_folder(folder, parent_folder) if response.files.empty?
      Rails.logger.warn "Multiple folders: more than 1 folder with same name: #{folder}" unless response.files.size == 1
      response.files[0].id
    end
  end
end
