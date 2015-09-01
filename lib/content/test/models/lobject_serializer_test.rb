require 'test_helper'
require 'content/models'

module Content
  module Test
    class LobjectSerializerTest < ContentTestBase

      def test_age_ranges
        assert_equal(
          {"min_age"=>30, "max_age"=>40, "extended_age"=>false, "range" => "30-40"},
          @as_json[:age_ranges].first
        )
      end

      def test_age_ranges_unique
        assert_equal 1, @as_json[:age_ranges].size
      end

      def test_sources
        assert_equal @lobject.documents.first.source_document.document.doc_id, @as_json[:sources][:learning_registry][0][:doc_id]
      end

      def test_identities
        assert_equal(
          'AMSER: Applied Math and Science Education Repository',
          @as_json[:identities].map{ |idt| idt['name'] }.first
        )
      end

      def test_identities_full
        actual_idt = identities(:amser)
        assert_equal(
          "#{actual_idt.id} #{actual_idt.name} publisher",
          @as_json[:identities].map{ |idt| idt['full'] }.first
        )
      end

      def test_identities_unique
        assert_equal 1, @as_json[:identities].size
      end

      def test_subjects
        assert_equal 'physics', @as_json[:subjects].map{ |kw| kw['name'] }.first
      end

      def test_subjects_unique
        assert_equal 1, @as_json[:subjects].size
      end

      def test_alignments
        assert_equal(
          'CCSS.Math.Practice.MP2', 
          @as_json[:alignments].map{ |alg| alg['name'] }.first
        )
      end

      def test_alignments_full
        actual_alg = Models::Alignment.find_by(name: 'CCSS.Math.Practice.MP2')
        assert_equal(
          "#{actual_alg.id} #{actual_alg.name} #{actual_alg.framework} #{actual_alg.framework_url}",
          @as_json[:alignments].map{ |alg| alg['full'] }.first
        )
      end

      def test_alignments_unique
        assert_equal 1, @as_json[:alignments].size
      end

      def test_resource_locators
        assert_equal(
          'https://www.khanacademy.org', 
          @as_json[:resource_locators].map{ |kw| kw['url'] }.first
        )
      end

      def test_resource_locators_unique
        assert_equal 1, @as_json[:resource_locators].size
      end

      def test_languages
        assert_equal 'es', @as_json[:languages].map{ |lang| lang['name'] }.first
      end

      def test_languages_unique
        assert_equal 1, @as_json[:languages].size
      end

      def test_resource_types
        assert_equal 'textbook', @as_json[:resource_types].map{ |lang| lang['name'] }.first
      end

      def test_resource_types_unique
        assert_equal 1, @as_json[:resource_types].size
      end

      def test_title
        assert_equal 'Physics', @as_json[:title]
      end

      def test_description
        assert_equal 'Physics', @as_json[:description]
      end
      
      def create_redundant_lobject
        lobject = Models::Lobject.create

        source_doc = Models::SourceDocument.create(source_type: 0)
        Models::LrDocument.create(doc_id: 1, source_document: source_doc)

        document = Models::Document.create(title: 'Physics Textbook', description: 'Physics Textbook', source_document: source_doc)
        other_document = Models::Document.create(title: 'Physics Textbook', description: 'Physics Textbook', source_document: source_doc)
        identity = identities(:amser)
        subject = subjects(:physics)
        language = languages(:es)
        resource_type = resource_types(:textbook)
        alignment = Models::Alignment.find_or_create_by(name: 'CCSS.Math.Practice.MP2', framework: 'Common Core State Standards for Mathematics', framework_url: 'http://asn.jesandco.org/resources/S2366907')

        lobject.age_ranges.concat(
          Models::LobjectAgeRange.create(min_age: 30, max_age: 40, extended_age: false, document: document),
          Models::LobjectAgeRange.create(min_age: 30, max_age: 40, extended_age: false, document: other_document)
        )

        lobject.lobject_alignments.concat(
          Models::LobjectAlignment.create(alignment: alignment, document: document),
          Models::LobjectAlignment.create(alignment: alignment, document: other_document)
        )

        lobject.lobject_descriptions.concat(
          Models::LobjectDescription.create(description: 'Physics', document: document),
          Models::LobjectDescription.create(description: 'Physics', document: other_document)
        )

        lobject.lobject_documents.concat(
          Models::LobjectDocument.create(document: document),
          Models::LobjectDocument.create(document: other_document)
        )

        lobject.lobject_identities.concat(
          Models::LobjectIdentity.create(identity: identity, identity_type: :publisher, document: document),
          Models::LobjectIdentity.create(identity: identity, identity_type: :publisher, document: other_document)
        )

        lobject.lobject_subjects.concat(
          Models::LobjectSubject.create(subject: subject, document: document),
          Models::LobjectSubject.create(subject: subject, document: other_document)
        )

        lobject.lobject_languages.concat(
          Models::LobjectLanguage.create(language: language, document: document),
          Models::LobjectLanguage.create(language: language, document: other_document)
        )

        lobject.lobject_resource_types.concat(
          Models::LobjectResourceType.create(resource_type: resource_type, document: document),
          Models::LobjectResourceType.create(resource_type: resource_type, document: other_document)
        )

        lobject.lobject_titles.concat(
          Models::LobjectTitle.create(title: 'Physics', document: document),
          Models::LobjectTitle.create(title: 'Physics', document: other_document)
        )

        lobject.lobject_urls << Models::LobjectUrl.create(url: urls(:khan))

        lobject
      end

      def setup
        super
        
        # An object with duplicated fields. Serializer should make those unique.
        @lobject = create_redundant_lobject
        @as_json = Models::LobjectSerializer.new(@lobject).as_indexed_json
      end
    end
  end
end
