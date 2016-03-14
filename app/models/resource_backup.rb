class ResourceBackup < ActiveRecord::Base
  validates :comment, presence: true

  before_create :dump!
  after_create :upload_dump!

  mount_uploader :dump, BackupUploader

  def restore!
    command = <<-CMD
      PGPASSWORD=#{config[:password]} \
      psql \
        --host=#{config[:host]} \
        --port=#{config[:port]} \
        --username=#{config[:username]} \
        #{config[:database]} < #{dump.path}
    CMD

    raise 'Failed to restore the dump' unless system(command)
  end

  private

  def config
    @config ||= ActiveRecord::Base.connection_config
  end

  def dump!
    time = I18n.l(Time.now, format: '%Y-%m-%d_%H-%M-%S')
    path = Rails.root.join('tmp', "resource_dump_#{time}.sql")

    connection = self.class.connection
    foreign_keys = connection.tables.map { |table| connection.foreign_keys(table) }.flatten
    resources_table = Resource.table_name
    tables = foreign_keys.select { |fk| fk.to_table == resources_table }.map(&:from_table)
    tables << resources_table
    table_options = tables.map { |table| "--table=#{table}" }.join(' ')

    command = <<-CMD
      PGPASSWORD=#{config[:password]} \
      pg_dump \
        --clean \
        --host=#{config[:host]} \
        --no-acl \
        --no-owner \
        --port=#{config[:port]} \
        --schema=public \
        --username=#{config[:username]} \
        #{table_options} \
        #{config[:database]} > #{path}
    CMD

    if (result = system(command))
      @path_to_dump = path
    else
      raise 'Failed to dump resources'
    end
  end

  def upload_dump!
    self.dump = @path_to_dump.open
    save!
  end
end
