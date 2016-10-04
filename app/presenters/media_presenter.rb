class MediaPresenter < ResourcePresenter
  include SoundcloudEmbed

  def media_title
    subject_title = subject.try(:classify) || ''
    resource_title = resource_type.try(:titleize) || ''
    "#{subject_title} #{resource_title}".strip
  end

  def embed_podcast
    if /soundcloud/ =~ url
      soundcloud_embed(url, try(:subject).try(:to_sym))
    end
  end

  def embed_video_url
    if /youtube/ =~ url
      embed_video_youtube_url
    elsif /vimeo/ =~ url
      embed_video_vimeo_url
    end
  end

  private

  def embed_video_youtube_url
    params = Rack::Utils.parse_query(URI(url).query)
    if id = params['v']
      "//www.youtube.com/embed/#{id}"
    end
  end

  def embed_video_vimeo_url
    if result = url.match(/https?:\/\/(www\.)?vimeo.com\/(\d+)/)
      "//player.vimeo.com/video/#{result[2]}"
    end
  end

end
