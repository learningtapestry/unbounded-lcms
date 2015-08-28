require 'content/models'

module Unbounded
  class LobjectPresenter < SimpleDelegator
    
    include Rails.application.routes.url_helpers
    
    def engageny_lobject_href(href)
      id = Content::Models::Lobject
      .select(:id)
      .joins(:urls)
      .where(urls: { url: "https://www.engageny.org#{href}" })
      .first
      .try(:id)

      if id
        unbounded_show_path(id: id)
      else
        href
      end
    end

    def engageny_downloadable_href(href)
      href.sub(
        '/sites/default/files/downloadable-resources',
        'http://k12-content.s3-website-us-east-1.amazonaws.com/downloadable-resources'
      )
    end

    def engageny_description
      html_desc = Nokogiri::HTML(description)

      html_desc.css('a').each do |a|
        if a['href'] =~ /^\/sites\/default\/files\/downloadable\-resources/
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
