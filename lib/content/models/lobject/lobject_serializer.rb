module Content
  module Models
    class LobjectSerializer
      attr_reader :lobject

      def initialize(lobject)
        @lobject = lobject
      end

      def as_indexed_json(options = {})
        lobject.as_json(except: [:indexed_at]).merge({
          age_ranges:  age_ranges,
          sources: sources,
          has_engageny_source: has_engageny_source,
          has_lr_source: has_lr_source,
          identities: identities,
          alignments: alignments,
          resource_locators: resource_locators,
          languages: languages,
          resource_types: resource_types,
          title: title,
          description: description,
          grades: grades,
          downloads: downloads,
          topics: topics,
          subjects: subjects
        })
      end

      protected

      def age_ranges
        # lobject
        # .age_ranges
        # .select(:min_age, :max_age, :extended_age)
        # .group(:min_age, :max_age, :extended_age)
        # .as_json(except: [:id])

        lobject
        .age_ranges
        .select(:min_age, :max_age, :extended_age)
        .group(:min_age, :max_age, :extended_age)
        .map do |ar|
          ar_h = {}

          ar_h[:min_age] = ar.min_age
          ar_h[:max_age] = ar.max_age
          ar_h[:extended_age] = ar.extended_age
          ar_h[:range] = ar.full

          ar_h
        end
        .as_json(except: [:id])
      end

      def sources
        sources = Hash.new { |h, k| h[k] = [] }

        lobject.documents.map(&:source_document).each do |source_doc|
          if source_doc.engageny?
            sources[:engageny] << { nid: source_doc.document.nid, active: source_doc.document.active }
          elsif source_doc.lr?
            sources[:learning_registry] << { doc_id: source_doc.document.doc_id }
          end
        end

        sources
      end

      def has_engageny_source
        lobject.documents.map(&:source_document).any? { |source_doc| source_doc.engageny? }
      end

      def has_lr_source
        lobject.documents.map(&:source_document).any? { |source_doc| source_doc.lr? }
      end

      def identities
        lobject
        .lobject_identities
        .select(:identity_type, :identity_id)
        .group(:identity_type, :identity_id)
        .map do |idt|
          idt_hash = idt.identity.as_json(only: [:id, :url, :name, :description, :public_key])
          idt_hash['identity_type'] = idt.identity_type
          idt_hash['full'] = "#{idt_hash['id']} #{idt_hash['name']} #{idt_hash['identity_type']}".strip
          idt_hash
        end
      end

      def alignments
        lobject
        .alignments
        .uniq
        .as_json(only: [:id, :name, :framework, :framework_url]).map do |alg|
          alg['full'] = "#{alg['id']} #{alg['name']} #{alg['framework']} #{alg['framework_url']}".strip
          alg
        end
      end

      def resource_locators
        lobject
        .urls
        .uniq
        .as_json(only: [:id, :url])
      end

      def languages
        lobject
        .languages
        .uniq
        .as_json(only: [:id, :name])
      end

      def resource_types
        lobject
        .resource_types
        .uniq
        .as_json(only: [:id, :name])
      end

      def grades
        lobject
        .grades
        .uniq
        .as_json(only: [:id, :grade])
      end

      def downloads
        lobject
        .downloads
        .uniq
        .map { |d| d.as_json(except: [:created_at, :updated_at]).merge('filename' => d.file.file.filename) }
      end

      def title
        lobject.title
      end

      def description
        lobject.description
      end

      def subjects
        lobject
        .lobject_subjects
        .map(&:subject)
        .uniq
        .as_json(only: [:id, :name])
      end

      def topics
        lobject
        .lobject_topics
        .map(&:topic)
        .uniq
        .as_json(only: [:id, :name])
      end
    end
  end
end
