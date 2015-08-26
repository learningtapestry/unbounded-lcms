require 'content/search/search_base'

module Content
  module Search
    class EngagenySearch < SearchBase
      def facet_fields
        {
          'sources.engageny' => 'sources.engageny.active',
          'resource_types' => 'resource_types.name.raw',
          'grades' => 'grades.grade.raw',
          'topics' => 'topics.name.raw',
          'subjects' => 'subjects.name.raw',
          'alignments' => 'alignments.name.raw'
        }
      end

      def restrict_results(dsl_context)
        dsl_context.must do
          term 'has_engageny_source' => true
        end
      end
    end
  end
end
