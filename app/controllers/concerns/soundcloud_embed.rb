require 'active_support/concern'

module SoundcloudEmbed
  extend ActiveSupport::Concern
  SUBJECT_COLORS = { math: '00a699', ela: 'f75b28', default: 'a269bf' }.freeze

  def soundcloud_embed(url, subject)
    color = SUBJECT_COLORS[subject || :default]
    oembed_url = "http://soundcloud.com/oembed?url=#{url}iframe=true&maxheight=166&color=#{color}&auto_play=false&format=json"
    RestClient.get(oembed_url) do |response|
      if response.code == 200
        oembed = JSON.parse(response)['html']
        return oembed.sub!('visual=true&', '') if oembed.present?
      end
    end
    nil
  end
end
