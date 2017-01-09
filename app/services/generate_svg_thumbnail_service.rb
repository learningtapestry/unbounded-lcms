class GenerateSVGThumbnailService
  include ERB::Util

  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def run
    ERB.new(template).result(binding)
  end

  def template
    @@template ||= File.read template_path
  end

  def template_path
    @@template_path ||= Rails.root.join('app', 'views', 'shared', 'social_thumb.svg.erb')
  end

  def asset_path(asset)
    ActionController::Base.helpers.asset_path(asset)
  end
end
