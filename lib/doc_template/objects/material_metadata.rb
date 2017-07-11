module DocTemplate
  module Objects
    class MaterialMetadata
      include Virtus.model

      attribute :identifier, String, default: ''

      def self.build_from(data)
        new(data.transform_keys { |k| k.to_s.underscore })
      end
    end
  end
end
