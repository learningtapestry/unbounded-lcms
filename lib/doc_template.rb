module DocTemplate
  FULL_TAG = /\[([^\]:]*)?:?\s*([^\]]*)?\]/mo
  ROOT_XPATH = '*//'
  STARTTAG_XPATH = 'span[contains(., "[")]'
  ENDTAG_XPATH = 'span[contains(., "]")]'

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
      cleaned_body = merge_split_tags(body_node)
      body_fragment = Nokogiri::HTML.fragment(cleaned_body)
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

    private

    def merge_split_tags(nodes)
      nodes
      #merge tags in a single tag if they are split
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
      @nodes.xpath(ROOT_XPATH + STARTTAG_XPATH).each do |node|
        tag_node = node.parent
        # skip invalid tags (not closing)
        next if FULL_TAG.match(tag_node.text).nil?
        tag_name, tag_description = FULL_TAG.match(tag_node.text).captures
        tag = registered_tags[tag_name]

        # extract the fragment related to the tag
        # replace the current node with the parsed
        # TODO: this replaces the nodes directly. ideally it should return a
        # copy that we then node.replace
        tag.parse(tag_node).render
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

    def selfremove
      start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
      end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
      @result.children[start_tag_index..end_tag_index].remove
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
      @result = node
      selfremove
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
