require 'securerandom'

require 'test_helper'
require 'content/merger'

module Content
  module Test
    class MergerTest < ContentTestBase

      def test_find_candidates_and_merge_creates
        lobject = Merger.find_candidates_and_merge(create_doc)
        assert_kind_of Models::Lobject, lobject
      end

      def test_find_candidates_and_merge_finds_candidates
        create_doc # Shares the same URL as the next one...
        lobject = Merger.find_candidates_and_merge(create_doc)
        assert_equal lobject.documents.size, 2
      end

      def test_find_candidates_and_merge_merges
        doc = create_doc
        lobject = Merger.find_candidates_and_merge(doc)
        
        other_doc_same_url = create_doc
        other_lobject = Merger.find_candidates_and_merge(other_doc_same_url)

        assert_equal lobject, other_lobject
      end

      def test_merge_marks_docs_as_merged
        docs = [create_doc, create_doc]
        Merger.merge(docs)
        docs.each(&:reload)
        refute docs.any? { |doc| doc.merged_at.nil? }
      end

      def test_merge_urls
        lobject = Merger.merge(create_doc)
        refute_empty lobject.urls
      end

      def test_merge_age_ranges
        doc = create_doc
        child_ar = Models::DocumentAgeRange.new(min_age: 5, max_age: 10, extended_age: false)
        adult_ar = Models::DocumentAgeRange.new(min_age: 18, max_age: 60, extended_age: true)
        doc.age_ranges.concat([child_ar, adult_ar])

        lobject = Merger.merge(doc)
        lobject_ar = lobject.age_ranges.first
        assert_equal(
          [child_ar.min_age, adult_ar.max_age, true],
          [lobject_ar.min_age, lobject_ar.max_age, lobject_ar.extended_age]
        )
      end

      def test_merge_lobject_identities
        doc1 = create_doc
        doc1.document_identities << Models::DocumentIdentity.new(identity: identities(:nsdl), identity_type: :publisher)

        doc2 = create_doc
        doc2.document_identities << Models::DocumentIdentity.new(identity: identities(:amser), identity_type: :submitter)

        lo = Merger.merge(doc1, doc2)

        identities = lo.lobject_identities.map { |idt| [idt.identity, idt.identity_type.to_sym] }
        expected_identities = [
          [identities(:nsdl), :publisher],
          [identities(:amser), :submitter]
        ]

        assert_equal expected_identities, identities
      end

      def test_merge_lobject_identities_doesnt_duplicate
        doc = create_doc
        doc.document_identities << dup_identity = Models::DocumentIdentity.new(
          identity: identities(:nsdl),
          identity_type: :submitter
        )

        doc2 = create_doc
        doc2.document_identities << dup_identity

        lo = Merger.merge(doc, doc2)
        assert_equal lo.lobject_identities.size, 1
      end

      def test_merge_subjects
        kws = [subjects(:math), subjects(:chemistry)]
        doc1 = create_doc
        doc1.subjects.concat(kws)
        lo = Merger.merge(doc1)

        more_kws = [subjects(:physics), subjects(:science)]
        doc2 = create_doc
        doc2.subjects.concat(more_kws)

        Merger.new(lo).merge!(doc2)

        assert_equal lo.subjects.to_a, (kws + more_kws).sort_by(&:name)
      end

      def test_merge_subjects_new_object
        kws = [subjects(:math), subjects(:chemistry)]
        doc1 = create_doc
        doc1.subjects.concat(kws)
        
        more_kws = [subjects(:physics), subjects(:science)]
        doc2 = create_doc
        doc2.subjects.concat(more_kws)

        lo = Merger.merge(doc1, doc2)
        assert_equal lo.subjects.to_a, (kws + more_kws).sort_by(&:name)
      end

      def test_merge_alignments
        alignments = [alignments(:mp1), alignments(:mp2)]
        doc1 = create_doc
        doc1.alignments.concat(alignments)
        lo = Merger.merge(doc1)

        more_alignments = [alignments(:mp3), alignments(:mp4)]
        doc2 = create_doc
        doc2.alignments.concat(more_alignments)

        Merger.new(lo).merge!(doc2)

        assert_equal lo.alignments.to_a, alignments+more_alignments
      end

      def test_merge_alignments_new_object
        alignments = [alignments(:mp1), alignments(:mp2)]
        doc1 = create_doc
        doc1.alignments.concat(alignments)
        
        more_alignments = [alignments(:mp3), alignments(:mp4)]
        doc2 = create_doc
        doc2.alignments.concat(more_alignments)

        lo = Merger.merge(doc1, doc2)
        assert_equal lo.alignments.to_a, alignments+more_alignments
      end

      def test_merge_documents
        candidates = [create_doc, create_doc]
        lobject = Merger.merge(candidates)

        more_candidates = [create_doc, create_doc]
        Merger.new(lobject).merge!(more_candidates)

        assert_equal lobject.documents.to_a, candidates+more_candidates
      end

      def test_merge_documents_new_object
        candidates = [create_doc, create_doc]
        lobject = Merger.merge(candidates)
        assert_equal lobject.documents.to_a, candidates
      end

      def test_merge_languages
        doc = create_doc
        doc.languages << languages(:en)

        lobject = Merger.merge(doc)

        doc2 = create_doc
        doc2.languages << languages(:es)

        Merger.new(lobject).merge!(doc2)

        assert_equal ['en', 'es'], lobject.languages.map(&:name)
      end

      def test_merge_languages_new_object
        doc = create_doc
        doc.languages << languages(:en)
        lobject = Merger.merge(doc)
        assert_equal 'en', lobject.languages.first.name
      end

      def test_merge_resource_types
        doc = create_doc
        doc.resource_types << resource_types(:video)
        lobject = Merger.merge(doc)

        doc2 = create_doc
        doc2.resource_types << resource_types(:textbook)
        Merger.new(lobject).merge!(doc2)

        assert_equal ['textbook', 'video'], lobject.resource_types.map(&:name)
      end

      def test_merge_resource_types_new_object
        doc = create_doc
        doc.resource_types << resource_types(:video)
        lobject = Merger.merge(doc)
        assert_equal 'video', lobject.resource_types.first.name
      end

      def test_merge_same_doc_overwrites
        lobject, updated = create_and_update_lobject
        assert_equal lobject, updated
      end

      def test_merge_same_doc_overwrites_titles
        updated = create_and_update_lobject[1]
        assert_equal ['Test 2'], updated.lobject_titles.map(&:title)
      end

      def test_merge_same_doc_overwrites_descriptions
        updated = create_and_update_lobject[1]
        assert_equal ['Test 2'], updated.lobject_descriptions.map(&:description)
      end

      def test_merge_same_doc_overwrites_age_ranges
        updated = create_and_update_lobject[1]
        assert_equal [5, 10, true], updated.age_ranges.map { |ar| [ar.min_age, ar.max_age, ar.extended_age] }.flatten
      end

      def test_merge_same_doc_overwrites_alignments
        updated = create_and_update_lobject[1]
        assert_equal [alignments(:mp2)], updated.alignments.to_a
      end

      def test_merge_same_doc_overwrites_identities
        updated = create_and_update_lobject[1]
        assert_equal [identities(:compadre)], updated.identities.to_a
      end

      def test_merge_same_doc_overwrites_subjects
        updated = create_and_update_lobject[1]
        assert_equal [subjects(:physics)], updated.subjects.to_a
      end

      def test_merge_same_doc_overwrites_languages
        updated = create_and_update_lobject[1]
        assert_equal [languages(:es)], updated.languages.to_a
      end

      def test_merge_same_doc_overwrites_resource_types
        updated = create_and_update_lobject[1]
        assert_equal [resource_types(:textbook)], updated.resource_types.to_a
      end

      def create_doc(attrs = {})
        Models::Document.create(attrs.merge(url: urls(:google)))
      end

      def create_and_update_lobject
        doc = Models::Document.create(title: 'Math Textbook', description: 'Math Textbook', url: urls(:google))
        doc.age_ranges << Models::DocumentAgeRange.new(min_age: 10, max_age: 20, extended_age: true)
        doc.document_alignments << Models::DocumentAlignment.new(alignment: alignments(:mp1))
        doc.document_identities << Models::DocumentIdentity.new(identity: identities(:nsdl), identity_type: :author)
        doc.document_subjects << Models::DocumentSubject.new(subject: subjects(:math))
        doc.document_languages << Models::DocumentLanguage.new(language: languages(:en))
        doc.document_resource_types << Models::DocumentResourceType.new(resource_type: resource_types(:video))

        created = Merger.find_candidates_and_merge(doc)

        doc.title = 'Test 2'
        doc.description = 'Test 2'
        doc.age_ranges = [Models::DocumentAgeRange.new(min_age: 5, max_age: 10, extended_age: true)]
        doc.alignments = [alignments(:mp2)]
        doc.document_identities = [Models::DocumentIdentity.new(identity_type: :publisher, identity: identities(:compadre))]
        doc.subjects = [subjects(:physics)]
        doc.languages = [languages(:es)]
        doc.resource_types = [resource_types(:textbook)]
        doc.save!

        updated = Merger.find_candidates_and_merge(doc)

        [created, updated]
      end

    end
  end
end
