require 'content/models'

module Unbounded
  class LobjectPresenter < SimpleDelegator

    include Content::Models
    include Rails.application.routes.url_helpers
    
    def engageny_lobject_href(href)
      href = "/#{href}" unless href.start_with?('/')

      url = Url.find_by(url: "https://www.engageny.org#{href}").canonical
      lobject_id = LobjectUrl.where(url: url).first.try(:lobject_id)

      if lobject_id
        unbounded_show_path(id: lobject_id)
      else
        "https://www.engageny.org#{href}"
      end
    end

    def engageny_downloadable_href(href)
      href = "/#{href}" unless href.start_with?('/')
      
      href.sub(
        '/sites/default/files',
        'http://k12-content.s3-website-us-east-1.amazonaws.com'
      )
    end

    def unbounded_description
      unless defined? @unbounded_description
        html_description_body.css('a').each do |a|
          if a['href'] =~ /^https:\/\/www\.engageny\.org\/(content|resource)/
            a['href'] = a['href'].sub('https://www.engageny.org', '')
          end

          if a['href'] =~ /^\/?sites\/default\/files/
            a['href'] = engageny_downloadable_href(a['href'])
            a['target'] = '_blank'
          elsif a['href'] =~ /^\/?(content|resource)/
            a['href'] = engageny_lobject_href(a['href'])
          end
        end

        @unbounded_description = html_description_body.to_html
      end

      @unbounded_description
    end

    def grade_description
      html_description_body.css('p')[0].to_html
    end

    def grade_additional_materials
      additional_materials = html_description_body.dup
      additional_materials.css('p')[0].remove
      additional_materials.to_html
    end

    protected

      def html_description
        @html_description ||= Nokogiri::HTML(description)
      end

      def html_description_body
        unless defined? @html_description_body
          parent_div = Nokogiri::HTML('<div />')
          body = html_description.css('body')[0]
          if body && body.children
            parent_div.children = body.children
          end
          @html_description_body = parent_div
        end

        @html_description_body
      end
  end
end
