# frozen_string_literal: true

module DocTemplate
  module Tags
    class LatexTag < BaseTag
      SPACE_RE = /[[:space:]]/
      TAG_NAME = 'latex'

      def parse(node, opts = {})
        @value = opts[:value].gsub(SPACE_RE, '')
        expression =
          begin
            # TODO: Refactor to handle GDoc in the ActiveJob
            if opts[:context_type]&.to_sym == :gdoc
              key = "documents-latex-equations/#{SecureRandom.hex(20)}.png"
              generate_image do |png|
                url = S3Service.upload key, png
                %(<img class="o-ld-latex" src="#{url}">)
              end
            else
              EmbedEquations.tex_to_svg @value
            end
          rescue StandardError => e
            raise if Rails.env.test?
            msg = "Error converting Latex expression: #{@value}"
            Rails.logger.warn "#{e.message} => #{msg}"
            msg
          end

        node.inner_html = node.inner_html.sub FULL_TAG, expression
        @result = node
        self
      end

      def tag_data
        { latex: value }
      end

      private

      attr_reader :value

      def generate_image
        svg_path =
          Tempfile.open(%w(tex-eq .svg)) do |svg|
            svg.write EmbedEquations.tex_to_svg(value)
            svg.path
          end

        png = Tempfile.new %w(tex-eq .png)
        begin
          system 'svgexport', svg_path, png.path
          yield File.read(png.path)
        ensure
          png.close true
        end
      end
    end
  end

  Template.register_tag(Tags::LatexTag::TAG_NAME, Tags::LatexTag)
end
