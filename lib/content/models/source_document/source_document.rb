module Content
  module Models
    class SourceDocument < ActiveRecord::Base
      scope :unconformed, -> { where(conformed_at: nil) }
      scope :conformed, -> { where.not(conformed_at: nil) }

      enum source_type: [:lr, :engageny]

      has_one :lr_document
      has_one :engageny_document

      def conformed!
        touch(:conformed_at)
      end

      def document
        if lr?
          lr_document
        elsif engageny?
          engageny_document
        end
      end

      def document=(doc)
        if lr?
          self.lr_document = doc
        elsif engageny?
          self.engageny_document = doc
        end
      end

      module Document
        def self.included(base)
          base.class_eval do
            belongs_to :source_document
          end
        end

        def conformed!
          source_document.conformed!
        end

        def initialize_source_document
          unless source_document
            self.source_document = SourceDocument.new(source_type: self.class::SOURCE_TYPE)
          end
        end
      end
    end
  end
end
