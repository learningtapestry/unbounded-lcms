module Content
  module Conformers
    class Conformer
      attr_accessor :source_document, :content, :document

      def initialize(source_document, document = Document.new)
        @source_document = source_document
        @document = document
      end

      def conform!
        Document.transaction do
          conform_doc_created_at
          conform_description
          conform_title
          conform_url
          conform_active
          conform_alignments
          conform_subjects
          conform_age_ranges
          conform_identities
          conform_source_document
          conform_languages
          conform_resource_types
          conform_grades
          conform_downloads

          document.save!
          source_document.conformed!

          document
        end
      end

      def conform_url; end

      def conform_active; end

      def conform_identities; end

      def conform_subjects; end

      def conform_lr_document; end

      def conform_alignments; end

      def conform_age_ranges; end

      def conform_doc_created_at; end

      def conform_description; end

      def conform_title; end

      def conform_languages; end

      def conform_resource_types; end

      def conform_grades; end

      def conform_downloads; end
    end
  end
end
