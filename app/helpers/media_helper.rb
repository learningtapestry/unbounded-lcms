module MediaHelper
  def embed_media(resource)
    if resource.video?
      embed_url = resource.embed_video_url
      content_tag(:iframe, nil, src: embed_url, allowfullscreen: true, frameborder: 0)
    elsif resource.podcast?
      embed_podcast = resource.embed_podcast
      embed_podcast.sub!('visual=true&', '') if embed_podcast
      embed_podcast.try(:html_safe)
    end
  end
end
