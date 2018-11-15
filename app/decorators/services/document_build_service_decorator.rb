# frozen_string_literal: true

DocumentBuildService.class_eval do
  def download(url)
    @downloader = DocumentDownloader::Gdoc.new(credentials, url, options).download
    @downloader.content
  end

  def find_resource
    dir = MetadataContext.new(template.metadata.with_indifferent_access).directory
    Resource.find_by_directory(dir)&.document
  end
end
