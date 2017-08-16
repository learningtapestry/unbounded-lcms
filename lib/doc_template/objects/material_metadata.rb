# frozen_string_literal: true

module DocTemplate
  module Objects
    class MaterialMetadata
      include Virtus.model
      KEY_PARAMS = %w(breadcrumb_level sheet_type type).freeze

      attribute :breadcrumb_level, String, default: 'lesson'
      attribute :identifier, String, default: ''
      attribute :name_date, String
      attribute :sheet_type, String, default: ''
      attribute :subject, String, default: ''
      attribute :title, String, default: ''
      attribute :type, String, default: 'default'
      attribute :vertical_text, String

      class << self
        def build_from(data)
          materials_data = data.transform_keys { |k| k.to_s.underscore }
                             .delete_if { |_, v| v.strip.blank? }
          KEY_PARAMS.each do |k|
            materials_data[k] = materials_data[k].to_s.downcase if materials_data.key?(k)
          end
          new(materials_data)
        end

        def dump(data)
          data.to_json
        end

        def load(data)
          new(data)
        end
      end
    end
  end
end
