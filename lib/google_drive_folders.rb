require 'fileutils'

require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/redis_token_store'

GDRIVE_APP    = ENV.fetch('GOOGLE_DRIVE_APP_NAME')
GDRIVE_ID     = ENV.fetch('GOOGLE_DRIVE_CLIENT_ID')
GDRIVE_SECRET = ENV.fetch('GOOGLE_DRIVE_CLIENT_SECRET')

GDRIVE_FOLDER_REGEXP = %r{drive.google.com/drive/folders/(.*)/?}

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
REDIS_URL = ENV.fetch('REDIS_URL', 'redis://localhost:6379')

class GoogleDriveFolders
  attr_reader :gdrive_key

  def initialize
    root_id = ENV.fetch('GDRIVE_ROOT').match(GDRIVE_FOLDER_REGEXP).try(:[], 1)

    # create persisted hash for the gdrive ids
    @gdrive_key = "gdrive:#{root_id}"
    redis.hset(gdrive_key, 'root', root_id)

    # expire in 1 week
    redis.expire(gdrive_key, 7 * 24 * 60 * 60)
  end

  def run
    Curriculum.trees
              .with_resources
              .order(:hierarchical_position)
              .each { |item| create_folder(item) }
  end

  def redis
    @redis ||= Redis.new(url: REDIS_URL)
  end

  def build_key(item)
    return nil if item.blank?

    if item.breadcrumb_short_title.end_with?(item.breadcrumb_short_piece)
      item.breadcrumb_short_title
    else
      item.breadcrumb_short_title + item.breadcrumb_short_piece
    end
  end

  def create_folder(item)
    key = build_key(item)

    return if redis.hget(gdrive_key, key).present?

    # get parent id
    parent = item.ancestors.first
    parent_id = redis.hget(gdrive_key, build_key(parent) || 'root')

    # create folder with proper parents
    metadata = {
      name: item.resource.short_title,
      mime_type: 'application/vnd.google-apps.folder',
      parents: [parent_id]
    }
    folder = gdrive_service.create_file(metadata, fields: 'id')

    # store folder id
    redis.hset(gdrive_key, key, folder.id)

    puts key
  end

  def gdrive_service
    @gdrive_service ||= begin
      service = Google::Apis::DriveV3::DriveService.new
      service.client_options.application_name = GDRIVE_APP
      service.authorization = authorize
      service
    end
  end

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  def authorize
    scope = Google::Apis::DriveV3::AUTH_DRIVE

    client_id   = Google::Auth::ClientId.new(GDRIVE_ID, GDRIVE_SECRET)
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: redis)
    authorizer  = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)

      puts "Open the following URL in the browser and enter the resulting code after authorization:\n"
      puts url
      puts "\nEnter code below:"
      code = STDIN.gets.chomp

      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
    end
    credentials
  end
end
