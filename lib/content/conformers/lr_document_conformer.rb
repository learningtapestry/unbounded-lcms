require 'content/models'

module Content
  module Conformers
    class LrDocumentConformer
      attr_accessor :lr_document, :content, :document

      def initialize(lr_document, document = Document.new)
        @lr_document = lr_document
        @content = lr_document.resource_data_content
        @document = document
      end

      def conform!
        Document.transaction do
          conform_doc_created_at
          conform_description
          conform_title
          conform_url
          conform_alignments
          conform_keywords
          conform_age_ranges
          conform_identities
          conform_lr_document
          conform_languages
          conform_resource_types

          document.save!
          lr_document.conformed!

          document
        end
      end

      def conform_url
        document.url =  Url.find_or_create_canonical(url: lr_document.resource_locator)
      end

      def conform_identities
        document.document_identities = raw_identities.map do |idt_type, idt|
          identity = Identity.find_or_create_by(name: idt)
          DocumentIdentity.new(identity: identity, identity_type: idt_type.to_sym)
        end
      end

      def conform_keywords
        wanted_keywords = raw_keywords.reject do |keyword|
          ignore_keywords.any? { |ignore| keyword.start_with?(ignore) }
        end
        
        document.keywords = wanted_keywords.map do |key|
          Keyword.find_or_create_by(name: Keyword.normalize_name(key)) do |created|
            created.doc_id = lr_document.doc_id
          end
        end
      end

      def conform_lr_document
        self.document.lr_document = lr_document
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

      def ignore_keywords
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

      def extract_raw_keywords
        Array.wrap(lr_document.keys)
      end

      def raw_keywords
        @raw_keywords ||= extract_raw_keywords
      end

      def extract_raw_identities
        lr_document.identity.select { |k,v| k != 'submitter_type' }
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
