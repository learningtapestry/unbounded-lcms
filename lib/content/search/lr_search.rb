require 'content/search/search_base'

module Content
  module Search
    class LrSearch < SearchBase
      def facet_fields
        {
          'age_ranges' => 'age_ranges.range',
          'alignments' => 'alignments.name.raw',
          'identities' => 'identites.name.raw',
          'languages' => 'languages.name.raw',
          'resource_types' => 'resource_types.name.raw',
          'subjects' => 'subjects.name.raw'
        }
      end

      def restrict_results(dsl_context)
        dsl_context.must do
          term 'has_lr_source' => true
        end
      end
    end
  end
end
