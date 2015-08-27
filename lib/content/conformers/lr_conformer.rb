require 'content/conformers/conformer'
require 'content/models'

module Content
  module Conformers
    class LrConformer < Conformer
      attr_accessor :content

      def initialize(source_document, document = Models::Document.new)
        super(source_document, document)
        @content = source_document.resource_data_content
      end

      def conform_url
        document.url =  Models::Url.find_or_create_canonical(url: source_document.resource_locator)
      end

      def conform_identities
        document.document_identities = raw_identities.map do |idt_type, idt|
          identity = Models::Identity.find_or_create_by(name: idt)
          Models::DocumentIdentity.new(identity: identity, identity_type: idt_type.to_sym)
        end
      end

      def conform_subjects
        wanted_subjects = raw_subjects.reject do |subject|
          ignore_subjects.any? { |ignore| subject.start_with?(ignore) }
        end
        
        document.subjects = wanted_subjects.map do |key|
          Models::Subject.find_or_create_by(name: Models::Subject.normalize_name(key)) do |created|
            created.doc_id = source_document.doc_id
          end
        end
      end

      def conform_source_document
        document.source_document = source_document.source_document
      end

      def conform_alignments
        raise NotImplementedError
      end

      def conform_age_ranges
        raise NotImplementedError
      end

      def conform_doc_created_at
        raise NotImplementedError
      end

      def conform_description
        raise NotImplementedError
      end

      def conform_title
        raise NotImplementedError
      end

      def conform_languages
        raise NotImplementedError
      end

      def conform_resource_types
        raise NotImplementedError
      end

      protected

      def ignore_subjects
        [
          'http://www.freesound',
          'oai:nsdl.org',
          'hdl:',
          'moreid:',
          'work-cmr-id:',
          'sdt.sulinet.hu:',
          'DIA (Digital Image Archive):',
          'oai:oai:',
          'lre:',
          'CNDP-numeribase:',
          'fnbe:',
          'MERLI:',
          'teachers domain:',
          'NSDL_SetSpec'
        ].map(&:downcase)
      end

      def extract_raw_subjects
        Array.wrap(source_document.keys)
      end

      def raw_subjects
        @raw_subjects ||= extract_raw_subjects
      end

      def extract_raw_identities
        source_document.identity.select { |k,v| k != 'submitter_type' }
      end

      def raw_identities
        @raw_identities ||= extract_raw_identities
      end

      def check_identity(identity_type, identity)
        raw_identities.any? do |ri_type, ri_identity|
          ri_type.to_sym == identity_type.to_sym and ri_identity.index(identity)
        end
      end
    end
  end
end
