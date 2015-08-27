module Content
  module Models
    class DocumentIdentity < ActiveRecord::Base
      belongs_to :document
      belongs_to :identity

      enum identity_type: [ :publisher, :submitter, :author, :curator, :signer, :owner ]
    end
  end
end
