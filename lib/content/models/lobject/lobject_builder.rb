module Content
  module Models
    class LobjectBuilder
      attr_reader :lobject
      
      def initialize
        @lobject = Lobject.new
      end

      def add_title(title)
        @lobject.lobject_titles.build(title: title)
        self
      end

      def set_organization(organization)
        @lobject.organization = organization
        self
      end

      def save
        @lobject.save! ; @lobject
      end

      def save!
        @lobject.save ; @lobject
      end
    end
  end
end
