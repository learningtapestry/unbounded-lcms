class MediaPresenter < ResourcePresenter
  include SoundcloudEmbed
  include VideoEmbed

  def media_title
    [subject, resource_type].compact.join(' ').titleize
  end

  def embed_podcast
    if /soundcloud/ =~ url
      soundcloud_embed(url, try(:subject).try(:to_sym))
    end
  end

  def embed_video_url
    return embed_video_vimeo_url if /vimeo/ =~ url
    embed_video_youtube_url
  end

  private

  def embed_video_youtube_url
    video_id = video_id(url)
    "//www.youtube.com/embed/#{video_id}" if video_id
  end

  def embed_video_vimeo_url
    video_id = video_id(url)
    "//player.vimeo.com/video/#{video_id}" if video_id
  end
end
