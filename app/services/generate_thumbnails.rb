class GenerateThumbnails
  attr_reader :model, :resource

  def initialize(model)
    @model = model
    @resource = model.is_a?(Curriculum) ? model.resource : model
    FileUtils.mkdir_p tmp_dir
  end

  def medias
    @@medias ||= [:all, :facebook, :pinterest, :twitter]
  end

  def generate
    medias.each do |media|
      file_path = tmp_dir.join("#{resource_type}_#{model.id}_#{media}.svg")
      # generate tmp svg file
      File.open(file_path, 'w') { |f| f.write(svg_content(media)) }
      # convert to png
      png_path = convert_to_png(file_path)

      # save thumbnail to s3
      thumb = SocialThumbnail.find_or_initialize_by(media: media, target: resource)
      thumb.image = File.open(png_path)
      thumb.save
    end
    # clean tmp image files
    files = Dir.glob(tmp_dir.join "#{resource_type}_#{model.id}_*.*")
    FileUtils.rm files
  end

  def tmp_dir
    Rails.root.join('tmp', 'svgs')
  end

  def resource_type
    resource.class.name.underscore
  end

  def svg_content(media)
    SVGSocialThumbnail.new(model, media: media).render
  end

  def convert_to_png(file_path)
    `batik-rasterizer #{file_path} -dpi 1200`
    file_path.to_s.gsub '.svg', '.png'
  end
end
