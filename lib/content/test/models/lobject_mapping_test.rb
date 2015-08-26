require 'content/test/test_helper'
require 'content/models'

module Content
  module Test
    class LobjectMappingTest < ContentTestBase
      def test_age_ranges
        assert_equal :nested, @mapping[:age_ranges][:type]
      end

      def test_identities
        expected_properties = {
          type: :nested,
          properties: {
            full: { 
              type: 'multi_field',
              fields: {
                full: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            },
            name: {
              type: 'multi_field',
              fields: {
                name: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            },
            identity_type: {
              type: 'multi_field',
              fields: {
                identity_type: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            }
          }
        }

        assert_equal expected_properties, @mapping[:identities]
      end

      def test_subjects
        expected_properties = {
          type: :nested,
          properties: {
            name: {
              type: 'multi_field',
              fields: {
                name: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            }
          }
        }

        assert_equal expected_properties, @mapping[:subjects]
      end

      def test_alignments
        expected_properties = {
          type: :nested,
          properties: {
            full: { 
              type: 'multi_field',
              fields: {
                full: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            },
            name: {
              type: 'multi_field',
              fields: {
                name: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            },
            framework: {
              type: 'multi_field',
              fields: {
                framework: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            },
            framework_url: {
              type: 'multi_field',
              fields: {
                framework_url: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            }
          }
        }

        assert_equal expected_properties, @mapping[:alignments]
      end

      def test_resource_locators
        expected_properties = {
          type: :nested,
          properties: {
            url: {
              type: 'multi_field',
              fields: {
                url: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            }
          }
        }

        assert_equal expected_properties, @mapping[:resource_locators]
      end

      def test_languages
        expected_properties = {
          type: :nested,
          properties: {
            name: {
              type: 'multi_field',
              fields: {
                name: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            }
          }
        }

        assert_equal expected_properties, @mapping[:languages]
      end

      def test_resource_types
        expected_properties = {
          type: :nested,
          properties: {
            name: {
              type: 'multi_field',
              fields: {
                name: { type: :string },
                raw: { type: :string, index: :not_analyzed },
              }
            }
          }
        }

        assert_equal expected_properties, @mapping[:resource_types]
      end

      def setup
        super
        
        @mapping = Lobject.mapping.to_hash[:lobject][:properties]
      end
    end
  end
end
