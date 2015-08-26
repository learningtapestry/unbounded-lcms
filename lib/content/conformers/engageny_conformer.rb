require 'content/conformers/conformer'

module Content
  module Conformers
    class EngagenyConformer < Conformer

      def conform_active
        document.active = source_document.active
      end

      def conform_url
        document.url = Url.find_or_create_canonical(url: source_document.url)
      end

      def conform_identities
        document.document_identities = [DocumentIdentity.new(
          identity_type: :publisher,
          identity: Identity.find_or_create_by(name: 'EngageNY')
        )]
      end

      def conform_subjects
        document.document_topics.concat(source_document.topics
          .select { |field| !field.empty? }
          .map { |topic|
            DocumentTopic.new(
              topic: Topic.find_or_create_by(name: Topic.normalize_name(topic))
            )
          })

        document.document_subjects.concat(source_document.subjects
          .select { |field| !field.empty? }
          .map { |sbj| 
            DocumentSubject.new(
              subject: Subject.find_or_create_by(name: Subject.normalize_name(sbj))
            )
          })
      end

      def conform_source_document
        document.source_document = source_document.source_document
      end

      def conform_alignments
        document.alignments.concat(source_document.standards
          .select { |field| !field.empty? }
          .map { |parent_std, stds|
            stds.map { |std| Alignment.find_or_create_by(name: "#{parent_std}.#{std}") }
          }.flatten)
      end

      def conform_doc_created_at
        document.doc_created_at = source_document.doc_created_at
      end

      def conform_description
        document.title = source_document.title
      end

      def conform_title
        document.description = source_document.description
      end

      def conform_languages
        document.languages << Language.find_or_create_by(name: 'en')
      end

      def conform_resource_types
        document.resource_types.concat(source_document.resource_types
          .select { |field| !field.empty? }
          .map { |rt| 
            ResourceType.find_or_create_by(name: ResourceType.normalize_name(rt))
          })
      end

      def conform_downloads
        document.downloads.concat(source_document.downloadable_resources
          .select { |field| !field.keys.empty? }
          .map { |dl| 
            Download.find_or_create_by(
              filename: dl['filename'],
              filesize: dl['filesize'],
              url: dl['uri'],
              content_type: dl['filemime'],
              title: dl['field_title_value']
            )
          })
      end

      def conform_grades
        document.grades.concat(source_document.grades
          .select { |field| !field.empty? }
          .map { |grade| 
            Grade.find_or_create_by(grade: Grade.normalize_grade(grade))
          })
      end
    end
  end
end
