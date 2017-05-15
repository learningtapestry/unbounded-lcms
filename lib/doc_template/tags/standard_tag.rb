module DocTemplate
  module Tags
    class StandardTag < BaseTag
      include ERB::Util

      TAG_DATA = {
        l: [
          { definition: 'Language', description: 'Conventions of Standard English' },
          { definition: 'Language', description: 'Conventions of Standard English' },
          { definition: 'Language', description: 'Knowledge of Language' },
          { definition: 'Language', description: 'Vocabulary Acquisition and Use' },
          { definition: 'Language', description: 'Vocabulary Acquisition and Use' },
          { definition: 'Language', description: 'Vocabulary Acquisition and Use' }
        ],
        rf: [
          { definition: 'Reading: Foundational Skills', description: 'Print Concepts' },
          { definition: 'Reading: Foundational Skills', description: 'Phonological Awareness' },
          { definition: 'Reading: Foundational Skills', description: 'Phonics and Word Recognition' },
          { definition: 'Reading: Foundational Skills', description: 'Fluency' }
        ],
        ri: [
          { definition: 'Reading: Informational Text', description: 'Key Ideas and Details' },
          { definition: 'Reading: Informational Text', description: 'Key Ideas and Details' },
          { definition: 'Reading: Informational Text', description: 'Key Ideas and Details' },
          { definition: 'Reading: Informational Text', description: 'Craft and Structure' },
          { definition: 'Reading: Informational Text', description: 'Craft and Structure' },
          { definition: 'Reading: Informational Text', description: 'Craft and Structure' },
          { definition: 'Reading: Informational Text', description: 'Integration of Knowledge and Ideas' },
          { definition: 'Reading: Informational Text', description: 'Integration of Knowledge and Ideas' },
          { definition: 'Reading: Informational Text', description: 'Integration of Knowledge and Ideas' },
          { definition: 'Reading: Informational Text', description: 'Range of Reading and Level of Text Complexity' }
        ],
        rl: [
          { definition: 'Reading: Literature', description: 'Key Ideas and Details' },
          { definition: 'Reading: Literature', description: 'Key Ideas and Details' },
          { definition: 'Reading: Literature', description: 'Key Ideas and Details' },
          { definition: 'Reading: Literature', description: 'Craft and Structure' },
          { definition: 'Reading: Literature', description: 'Craft and Structure' },
          { definition: 'Reading: Literature', description: 'Craft and Structure' },
          { definition: 'Reading: Literature', description: 'Integration of Knowledge and Ideas' },
          { definition: 'Reading: Literature', description: 'Integration of Knowledge and Ideas' },
          { definition: 'Reading: Literature', description: 'Integration of Knowledge and Ideas' },
          { definition: 'Reading: Literature', description: 'Range of Reading and Level of Text Complexity' }
        ],
        sl: [
          { definition: 'Speaking & Listening', description: 'Comprehension and Collaboration' },
          { definition: 'Speaking & Listening', description: 'Comprehension and Collaboration' },
          { definition: 'Speaking & Listening', description: 'Comprehension and Collaboration' },
          { definition: 'Speaking & Listening', description: 'Presentation of Knowledge and Ideas' },
          { definition: 'Speaking & Listening', description: 'Presentation of Knowledge and Ideas' },
          { definition: 'Speaking & Listening', description: 'Presentation of Knowledge and Ideas' }
        ],
        w: [
          { definition: 'Writing', description: 'Text Types and Purposes' },
          { definition: 'Writing', description: 'Text Types and Purposes' },
          { definition: 'Writing', description: 'Text Types and Purposes' },
          { definition: 'Writing', description: 'Production and Distribution of Writing' },
          { definition: 'Writing', description: 'Production and Distribution of Writing' },
          { definition: 'Writing', description: 'Production and Distribution of Writing' },
          { definition: 'Writing', description: 'Research to Build and Present Knowledge' },
          { definition: 'Writing', description: 'Research to Build and Present Knowledge' },
          { definition: 'Writing', description: 'Research to Build and Present Knowledge' },
          { definition: 'Writing', description: 'Range of Writing' }
        ]
      }.freeze
      STANDARD_RE = /[^\[\]]*\[(ela\.)?(rl|ri|rf|w|sl|l)\.\d+\.(\d{1,2})\]/i
      TAG_NAME = /^(ela\.)?(rl|ri|rf|w|sl|l)\.\d+\.\d{1,2}/ # RL.2.4 or ELA.RL.2.4
      TAG_RE = /\[[^\]]*\]/
      TAG_SEPARATOR = '[separator]'.freeze
      TEMPLATE = 'standard.html.erb'.freeze

      def parse(node, _)
        content = render_template node
        loop do
          break unless STANDARD_RE =~ content
          content = render_template Nokogiri::HTML.fragment(content)
        end

        # preserve `li` element
        if node.name == 'li'
          node.replace "<li>#{content}</li>"
        else
          node.replace content
        end

        @result = node
        self
      end

      private

      # Extracting content outside the tag
      # TODO: Extract to the parent class
      def fetch_data(source)
        @preserved_style = %r{<span (style=[^.>]*)>[^<]+</span>$}.match(source).try(:[], 1)
        {}.tap do |result|
          data = source.squish
                   .sub(TAG_RE, TAG_SEPARATOR)
                   .split(TAG_SEPARATOR, 2)
                   .reject(&:blank?)
          break unless data
          result[:prepend] = data[0]
          result[:append] = data[1]
        end
      end

      def fetch_standard(text)
        return unless (matches = STANDARD_RE.match text)

        standard_name = matches[2].downcase.to_sym
        standard_num = matches[3].to_i - 1
        TAG_DATA[standard_name].try(:[], standard_num)
      end

      def render_template(node)
        @data = fetch_data node.inner_html
        @standard_shortcut = TAG_RE.match(node.content).try(:[], 0).try(:gsub, /\[|\]/, '')

        standard_data = fetch_standard node.content
        if standard_data.present?
          @definition = standard_data[:definition]
          @description = standard_data[:description]
        end

        template = File.read template_path(TEMPLATE)
        ERB.new(template).result(binding)
      end
    end
  end

  Template.register_tag(Tags::StandardTag::TAG_NAME, Tags::StandardTag)
end
