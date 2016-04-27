class MediaPresenter < ResourcePresenter
  SUBJECT_COLORS = { math: '00a699', ela: 'f75b28', default: 'a269bf' }.freeze

  def media_title
    subject_title = subject.try(:upcase) || ''
    resource_title = resource_type.try(:titleize) || ''
    "#{subject_title} #{resource_title}".strip
  end

  def embed_podcast
    if /soundcloud/ =~ url
      color = SUBJECT_COLORS[try(:subject).try(:to_sym) || :default]
      oembed_url = "http://soundcloud.com/oembed?url=#{url}&iframe=true&maxheight=166&color=#{color}&auto_play=false&format=json"
      RestClient.get(oembed_url) do |response|
        JSON.parse(response)['html'] if response.code == 200
      end
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
