require 'content/models'

module Content
  class Merger
    attr_reader :lobject

    def initialize(lobject = Lobject.new)
      @lobject = lobject
    end

    def self.find_candidates(document)
      Document
      .unmerged
      .where(url_id: document.url.chain.map(&:id))
      .where.not(id: document.id)
      .<< document
    end

    def self.find_candidates_and_merge(document)
      Lobject.transaction do
        lobject = document.url.lobjects.first || Lobject.new
        Merger.new(lobject).merge!(find_candidates(document))
      end
    end

    def self.merge(*documents)
      new.merge!(*documents)
    end

    def merge!(*documents)
      if documents.size == 1
        documents = Array.wrap(documents[0])
      end

      Lobject.transaction do
        documents.each do |document|
          merge_urls(document)
          merge_titles(document)
          merge_descriptions(document)
          merge_age_ranges(document)
          merge_identities(document)
          merge_subjects(document)
          merge_topics(document)
          merge_alignments(document)
          merge_documents(document)
          merge_languages(document)
          merge_resource_types(document)
          merge_grades(document)
          merge_downloads(document)

          document.merged!
        end

        lobject.save!

        lobject
      end

    end

    def merge_urls(document)
      if lobject.urls.empty?
        lobject.urls << document.url.canonical
      end
    end

    def merge_titles(document)
      lobject.lobject_titles.where(document: document).destroy_all

      lobject.lobject_titles << LobjectTitle.new(
        title: document.title, 
        document: document,
        doc_created_at: document.doc_created_at
      )
    end

    def merge_descriptions(document)
      lobject.lobject_descriptions.where(document: document).destroy_all

      lobject.lobject_descriptions << LobjectDescription.new(
        description: document.description, 
        document: document,
        doc_created_at: document.doc_created_at
      )
    end

    def merge_age_ranges(document)
      lobject.lobject_age_ranges.where(document: document).destroy_all

      normalized = document.normalized_age_range
      return if normalized.nil?

      lobject.age_ranges << LobjectAgeRange.new(
        min_age: normalized[:min],
        max_age: normalized[:max],
        extended_age: normalized[:extended],
        document: document
      )
    end

    def merge_identities(document)
      lobject.lobject_identities.where(document: document).destroy_all

      document.document_identities.each do |doc_idt|
        next if lobject.lobject_identities.any? { |idt|
          idt.identity == doc_idt.identity &&
          idt.identity_type == doc_idt.identity_type
        }
        lobject.lobject_identities << LobjectIdentity.new(
          identity: doc_idt.identity, 
          identity_type: doc_idt.identity_type,
          document: doc_idt.document
        )
      end
    end

    def merge_subjects(document)
      lobject.lobject_subjects.where(document: document).destroy_all

      document.document_subjects.each do |doc_sbj|

        next if lobject.lobject_subjects.any? do |lob_sbj|
          lob_sbj.subject_id == doc_sbj.subject_id
        end

        lobject.lobject_subjects << LobjectSubject.new(
          document_id: document.id,
          subject_id: doc_sbj.subject_id
        )
      end
    end

    def merge_topics(document)
      lobject.lobject_topics.where(document: document).destroy_all

      document.document_topics.each do |doc_sbj|

        next if lobject.lobject_topics.any? do |lob_sbj|
          lob_sbj.topic_id == doc_sbj.topic_id
        end

        lobject.lobject_topics << LobjectTopic.new(
          document_id: document.id,
          topic_id: doc_sbj.topic_id
        )
      end
    end

    def merge_alignments(document)
      lobject.lobject_alignments.where(document: document).destroy_all

      document.alignments.each do |ag|
        next if lobject.alignments.include?(ag)
        lobject.lobject_alignments << LobjectAlignment.new(
          document: document,
          alignment: ag
        )
      end
    end

    def merge_documents(document)
      lobject.lobject_documents.where(document: document).destroy_all

      lobject.documents << document
    end

    def merge_languages(document)
      lobject.lobject_languages.where(document: document).destroy_all
        
      document.languages.each do |lang|
        next if lobject.languages.include?(lang)
        lobject.lobject_languages << LobjectLanguage.new(
          document: document,
          language: lang
        )
      end
    end

    def merge_resource_types(document)
      lobject.lobject_resource_types.where(document: document).destroy_all

      document.resource_types.each do |res|
        next if lobject.resource_types.include?(res)
        lobject.lobject_resource_types << LobjectResourceType.new(
          document: document,
          resource_type: res
        )
      end
    end

    def merge_grades(document)
      lobject.lobject_downloads.where(document: document).destroy_all

      document.downloads.each do |dl|
        next if lobject.downloads.include?(dl)
        lobject.lobject_downloads << LobjectDownload.new(
          document: document,
          download: dl
        )
      end
    end

    def merge_downloads(document)
      lobject.lobject_grades.where(document: document).destroy_all

      document.grades.each do |grade|
        next if lobject.grades.include?(grade)
        lobject.lobject_grades << LobjectGrade.new(
          document: document,
          grade: grade
        )
      end
    end
  end
end
