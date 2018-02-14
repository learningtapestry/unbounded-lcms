# frozen_string_literal: true

class MediaPresenter < ResourcePresenter
  def media_title
    [subject, resource_type].compact.join(' ').titleize
  end

  def embed_podcast
    MediaEmbed.soundcloud(url, try(:subject).try(:to_sym)) if /soundcloud/ =~ url
  end

  def embed_video_url
    /vimeo/ =~ url ? embed_video_vimeo_url : embed_video_youtube_url
  end

  private

  def embed_video_youtube_url
    video_id = MediaEmbed.video_id(url)
    "//www.youtube.com/embed/#{video_id}" if video_id
  end

  def embed_video_vimeo_url
    video_id = MediaEmbed.video_id(url)
    "//player.vimeo.com/video/#{video_id}" if video_id
  end
end
