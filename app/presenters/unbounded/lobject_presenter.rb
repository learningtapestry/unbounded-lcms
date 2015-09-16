require 'content/models'

module Unbounded
  class LobjectPresenter < SimpleDelegator

    include Content::Models
    include Rails.application.routes.url_helpers
    
    def engageny_lobject_href(href)
      url = Url.find_by(url: "https://www.engageny.org#{href}").canonical
      lobject_id = LobjectUrl.where(url: url).first.try(:lobject_id)

      if lobject_id
        unbounded_show_path(id: lobject_id)
      else
        "https://www.engageny.org#{href}"
      end
    end

    def engageny_downloadable_href(href)
      href.sub(
        '/sites/default/files',
        'http://k12-content.s3-website-us-east-1.amazonaws.com'
      )
    end

    def engageny_description
      html_desc = Nokogiri::HTML(description)

      html_desc.css('a').each do |a|
        if a['href'] =~ /^https:\/\/www\.engageny\.org\/(content|resource)/
          a['href'] = a['href'].sub('https://www.engageny.org', '')
        end

        if a['href'] =~ /^\/sites\/default\/files/
          a['href'] = engageny_downloadable_href(a['href'])
          a['target'] = '_blank'
        elsif a['href'] =~ /^\/(content|resource)/
          a['href'] = engageny_lobject_href(a['href'])
        end
      end

      html_desc.to_html
    end
  end
end
