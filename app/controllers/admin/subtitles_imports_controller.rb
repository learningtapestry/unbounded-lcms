class Admin::SubtitlesImportsController < Admin::AdminController
  def index
    if (ids = Rails.cache.read(:imported_resource_ids)).kind_of?(Array)
      @resources = Resource.where(id: ids)
    else
      redirect_to :new_admin_subtitles_import
    end
  end

  def new
    @importer = SubtitlesImporter.new
  end

  def create
    file = params[:subtitles_importer][:file] rescue nil
    @importer = SubtitlesImporter.new(file)
    if @importer.import
      Rails.cache.write(:imported_resource_ids, @importer.resources.map(&:id))
      redirect_to :admin_subtitles_imports
    else
      render :new
    end
  end
end
