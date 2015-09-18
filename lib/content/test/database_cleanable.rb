module Content
  module Test
    module DatabaseCleanable
      def setup
        super
        DatabaseCleaner[:active_record].strategy = :transaction
        DatabaseCleaner.start
      end

      def teardown
        super
        DatabaseCleaner.clean
      end
    end
  end
end
