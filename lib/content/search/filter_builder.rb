module Content
  module Search
    class FilterBuilder
      attr_reader :filters

      def initialize(filters)
        @filters = filters
      end

      def self.build(filters)
        new(filters).build
      end

      def build
        _self = self

        Esbuilder.build do
          filter do
            bool do
              must { term 'has_engageny_source' => true }

              if filters.has_key?('active')
                _self.add_active_filter(self, filters['active'])
              end

              if filters.has_key?('active')
                _self.add_active_filter(self, filters['active'])
              end

              if filters.has_key?('active')
                _self.add_active_filter(self, filters['active'])
              end

              if filters.has_key?('active')
                _self.add_active_filter(self, filters['active'])
              end

              if filters.has_key?('active')
                _self.add_active_filter(self, filters['active'])
              end
            end
          end
        end
      end

      def add_active_filter(dsl_context, active)
        dsl_context.must do
          nested do
            path 'sources.engageny'
            filter do
              must { term 'sources.engageny.active' => active }
            end
          end
        end
      end
    end
  end
end
