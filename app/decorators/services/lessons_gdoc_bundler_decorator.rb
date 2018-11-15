# frozen_string_literal: true

LessonsGdocBundler.class_eval do
  def drive_service
    @drive_service ||= GoogleApi::DriveService.build(
      Google::Apis::DriveV3::DriveService,
      nil,
      gdoc_folder: root_folder
    )
  end
end
