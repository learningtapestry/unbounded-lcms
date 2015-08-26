require 'content/conformers/lr_conformer'
require 'content/models'

module Content
  module Conformers
    class LrLrmiConformer < LrConformer

      def conform_doc_created_at
        document.doc_created_at = to_a(content['dateCreated'])[0] || Time.now
      end

      def conform_description
        document.description = to_a(content['description'])[0]
      end

      def conform_title
        document.title = to_a(content['name'])[0]
      end
      
      def conform_alignments
        document.alignments = to_a(content['educationalAlignment'])
          .map { |alignment| parse_alignment(alignment) }
          .flatten
      end

      def conform_age_ranges
        typical_age_ranges = to_a(content['typicalAgeRange'])

        if typical_age_ranges.empty?
          document.age_ranges = []
          return
        end

        age_ranges = typical_age_ranges
          .map { |typical_age_range| age_range_from_string(typical_age_range) }
          .uniq
          .sort

        document.age_ranges = age_ranges
      end

      def conform_languages
        languages = to_a(content['inLanguage']).map do |v| 
          Language.find_or_create_by(name: v.strip.downcase)
        end

        document.languages = languages
      end

      def conform_resource_types
        resource_types = to_a(content['learningResourceType']).map do |v| 
          ResourceType.find_or_create_by(name: v.strip.downcase)
        end

        document.resource_types = resource_types
      end

      protected

      def to_a(key)
        Array.wrap(key)
      end

      def extract_raw_subjects
        lrmi_subjects = to_a(content['about']).map { |kw| Subject.normalize_name(kw) }
        (super + lrmi_subjects).uniq
      end

      def parse_alignment(alignment)
        name = to_a(alignment['targetName'])[0]
        framework = to_a(alignment['educationalFramework'])[0]
        framework_url = to_a(alignment['targetUrl'])[0]

        if check_identity(:submitter, 'doe.k12.ga.us') and (names = name.split(',')).size > 1
          names.map do |sub_name|
            Alignment.find_or_create_by(
              name: sub_name,
              framework: framework,
              framework_url: framework_url
            )
          end
        else
          Alignment.find_or_create_by(
            name: name,
            framework: framework,
            framework_url: framework_url
          )
        end
      end

      def age_range_from_string(s)
        age_range = DocumentAgeRange.new

        minmax = s.to_s.split('-')

        if minmax.size == 1
          if minmax[0].end_with?('+')
            age_range.min_age = minmax[0][0..-2].to_i
            age_range.extended_age = true
          else
            age_range.min_age = minmax[0].to_i
            age_range.extended_age = false
          end
        elsif minmax.size == 2
          age_range.min_age = minmax[0]

          if minmax[1].end_with?('+')
            age_range.max_age = minmax[1][0..-2].to_i
            age_range.extended_age = true
          else
            age_range.max_age = minmax[1].to_i
            age_range.extended_age = false
          end
        else
          return nil
        end

        age_range
      end
    end
  end
end
