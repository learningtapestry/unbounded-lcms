require 'content/models/source_document/source_document'

module Content
  module Models
    class EngagenyDocument < ActiveRecord::Base
      SOURCE_TYPE = :engageny

      include SourceDocument::Document
    end
  end
end
