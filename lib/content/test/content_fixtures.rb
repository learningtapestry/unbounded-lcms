module Content
  module Test
    module ContentFixtures
      def self.included(base)
        base.instance_eval do
          self.fixture_path = File.join(TEST_PATH, 'fixtures')

          Content::Models.constants
          .map { |c| Content::Models.const_get(c) }
          .select { |c| c <= ActiveRecord::Base }
          .each do |c|
            set_fixture_class c.name.demodulize.tableize => c
          end

          fixtures :all
        end
      end
    end
  end
end
