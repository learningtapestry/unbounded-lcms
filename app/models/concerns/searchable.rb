require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_indexing

    after_commit :index_document, on: [:create, :update], if: :should_index?
    after_commit :delete_document, on: :destroy, if: :should_index?

    def index_document
      begin
        doc = self.class.search_model.build_from self
        search_repo.save(doc)
      rescue Faraday::ConnectionFailed; end
    end

    def delete_document
      begin
        doc = self.class.search_model.build_from self
        search_repo.delete(doc)
      rescue Faraday::ConnectionFailed; end
    end

    def search_repo
      @search_repo ||= Search::Repository.new
    end

    def self.search_model
      @search_model ||= Search::Document
    end

    def self.search(term, options={})
      search_model.search term, options.merge!(model_type: self.name.underscore)
    end

    def should_index?
      !skip_indexing && search_repo.index_exists?
    end

  end
end
