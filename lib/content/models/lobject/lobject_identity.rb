module Content
  module Models
    class LobjectIdentity < ActiveRecord::Base
      acts_as_forest
      
      belongs_to :lobject
      belongs_to :document
      belongs_to :identity

      enum identity_type: [ :publisher, :submitter, :author, :curator, :signer, :owner ]

      def self.from_doc_identity(doc_identity)
        new(identity: doc_identity.identity, identity_type: doc_identity.identity_type)
      end
    end
  end
end
