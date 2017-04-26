module DocTemplate
  FULL_TAG = /\[([^\]]*)?\]/om
  TAG_XPATH = 'p/*[contains(., "[")]'

  class Template
    # a registry for available tags and respective classes
    class TagRegistry
      include Enumerable

      def initialize
        @tags = {}
      end

      # returns the default tag if the tag is unknown
      def [](tag_name)
        tag_to_load = @tags.key?(tag_name) ? tag_name : 'default'
        @tags[tag_to_load]
      end

      def []=(tag_name, klass)
        @tags[tag_name] = klass
      end

      private

      def load_class(klass_name)
        Object.const_get(klass_name)
      end
    end

    def self.parse(source)
      template = Template.new
      template.parse(source)
    end

    def parse(source)
      doc = Nokogiri::HTML(source)
      body_node = doc.xpath('//html/body/*').to_s
      body_fragment = Nokogiri::HTML.fragment(body_node)
      @root = Document.parse(body_fragment)
    end

    def self.register_tag(name, klass)
      self.tags[name.to_s] = klass
    end

    def self.tags
      @tags ||= TagRegistry.new
    end

    def render
      return '' if @root.nil?
      @root.render
    end
  end

  class Document
    def self.parse(nodes)
      doc = new
      doc.parse(nodes)
    end

    def parse(nodes)
      @nodes = nodes
      # identify the tag, take the siblings or enclosing and send it to the
      # relative tag class to render it

      # find all tags
      #
      @nodes.xpath(TAG_XPATH).each do |node|
        # extract the tag and the extra info
        tag_name, tag_description = FULL_TAG.match(node.text).captures
        tag = registered_tags[tag_name]

        # extract the fragment related to the tag
        # replace the current node with the parsed
        # TODO: this replaces the nodes directly. ideally it should return a
        # copy that we then node.replace
        tag.parse(node).render
      end

      self
    end

    def render
      @nodes.to_html
    end

    private

    def registered_tags
      Template.tags
    end
  end

  class Tag
    def self.parse(node)
      tag = new
      tag.parse(node)
    end

    def parse(node)
      raise NotImplementedError
    end

    def render
      raise NotImplementedError
    end
  end

  class SectionTag < Tag
  end
  Template.register_tag('section'.freeze, SectionTag)

  class GroupTag < Tag
  end
  Template.register_tag('group'.freeze, GroupTag)

  class DefaultTag < Tag
    def parse(node)
      @node = node
      @result = node.parent.parent
      node.remove
      self
    end

    def render
      @result
    end
  end
  Template.register_tag('default'.freeze, DefaultTag)

  class MetaTable
    def self.parse(node)
      raise NotImplementedError, "parse and return a metadata hash"
      table = new
      table.parse(node)
    end

    def parse(node)
    end

    def render
    end
  end
end
