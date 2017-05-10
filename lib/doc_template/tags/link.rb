module DocTemplate
  class LinkTag < Tag
    def parse(node, opts = {})
      # preserve the node content and replace only the tag by the link
      content = node.content.gsub("\n", '<br />')
                            .gsub(/\[#{self.class::TAG_NAME}: .*\]/i, link(opts[:value]))
      node.replace content

      @result = node
      self
    end

    private

    def link(value)
      title, text = value.split(';').map &:strip
      # If we don't have a text, use the fa-book icon
      text = text.present? ? "<b>#{text}</b>" : '<i class="fa fa-book"></i>'

      # TODO: get links from mapping, as metioned here:
      # https://github.com/learningtapestry/unbounded/issues/78
      href = '#'

      "<a href=\"#{href}\" target=\"_blank\" title=\"#{title}\">#{text}</a>"
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
