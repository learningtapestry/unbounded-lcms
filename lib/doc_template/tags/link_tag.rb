module DocTemplate
  class LinkTag < Tag
    def parse(node, opts = {})
      # preserve the node content and replace only the tag by the link
      content = node.to_s.gsub /\[#{self.class::TAG_NAME}: .*\]/i, link(opts)
      node.replace content

      @result = node
      self
    end

    private

    def link(opts)
      title, text = opts[:value].split(';').map &:strip
      # If we don't have a text, use the fa-book icon
      text = text.present? ? "<b>#{text}</b>" : '<i class="fa fa-book"></i>'
      href = build_href(title, opts[:metadata])

      "<a href=\"#{href}\" target=\"_blank\" title=\"#{title}\">#{text}</a>"
    end

    def build_href(title, metadata)
      # if the first param is a url, then use it directly
      return title if title =~ URI::regexp

      # if we don't have proper metadata info, just use a placeholder
      return '#' unless metadata

      # build the path for unbounded-supplemental-materials on s3
      path = [:subject, :grade, :module, :unit, :topic].map do |key|
        if metadata[key].present?
          # if its a number return `key-number` else return the parameterized value
          /^(\d+)$/.match(metadata[key]){ |num| "#{key}-#{num}" } || metadata[key].try(:parameterize)
        end
      end.compact.join('/')
      filename = title.ends_with?('.pdf') ? title : "#{title}.pdf"
      "https://unbounded-supplemental-materials.s3.amazonaws.com/#{path}/#{filename}"
    end
  end

  class QrdTag < LinkTag
    TAG_NAME = 'qrd'.freeze
  end

  class ImTag < LinkTag
    TAG_NAME = 'im'.freeze
  end

  class PosTag < LinkTag
    TAG_NAME = 'pos'.freeze
  end

  class SgimTag < LinkTag
    TAG_NAME = 'sgim'.freeze
  end

  Template.register_tag(QrdTag::TAG_NAME, QrdTag)
  Template.register_tag(ImTag::TAG_NAME, ImTag)
  Template.register_tag(PosTag::TAG_NAME, PosTag)
  Template.register_tag(SgimTag::TAG_NAME, SgimTag)
end
