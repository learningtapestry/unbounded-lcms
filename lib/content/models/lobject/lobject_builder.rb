module Content
  module Models
    class LobjectBuilder
      attr_reader :lobject
      
      def initialize
        @lobject = Lobject.new
      end

      def add_description(description)
        @lobject.lobject_descriptions.build(description: description)
        self
      end

      def add_grade(grade)
        @lobject.lobject_grades.build(
          grade: Grade.where(grade: grade).first_or_create.canonical
        )
        self
      end

      def add_publisher(publisher)
        @lobject.lobject_identities.build(
          identity: Identity.where(name: publisher).first_or_create.canonical,
          identity_type: LobjectIdentity.identity_types[:publisher]
        )
        self
      end

      def add_resource_type(resource_type)
        @lobject.lobject_resource_types.build(
          resource_type: ResourceType.where(name: resource_type).first_or_create.canonical
        )
        self
      end

      def add_standard(standard)
        @lobject.lobject_alignments.build(
          alignment: Alignment.where(name: standard).first_or_create.canonical
        )
        self
      end

      def add_subject(subject)
        @lobject.lobject_subjects.build(
          subject: Subject.where(name: subject).first_or_create.canonical
        )
        self
      end

      def add_title(title)
        @lobject.lobject_titles.build(title: title)
        self
      end

      def add_url(url)
        @lobject.lobject_urls.build(
          url: Url.where(url: url).first_or_create.canonical
        )
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
