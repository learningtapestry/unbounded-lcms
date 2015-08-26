module Content
  module FormatParsers
    class FormatParser
      attr_accessor :envelope, :resource_data, :content, :valid

      def initialize(envelope, resource_data)
        self.envelope = envelope
        self.resource_data = resource_data
        self.content = nil
      end

      def self.parse(envelope, resource_data)
        parser = new(envelope, resource_data)
        parser.parse
        parser
      end

      def parse
        raise NotImplementedError
      end

      def format
        self.class::FORMAT
      end

      def valid?
        !content.nil?
      end
    end
  end
end
