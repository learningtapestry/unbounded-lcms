module Unbounded
  module Admin
    module LobjectHelper
      def attachment_content_type(download)
        t("unbounded.content_type.#{download.content_type}") rescue download.content_type
      end

      def attachment_url(download)
        if download.url.present?
          download.url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
        else
          download.file.url
        end
      end

      def language_collection_options
        Language.order(:name).map { |lang| [lang.name, lang.id ] }
      end

      def lobject_status(lobject)
        status = lobject.hidden? ? :hidden : :active
        t(status, scope: :lobject_statuses)
      end

      def related_resource_type(lobject)
        resource_types = lobject.resource_types.pluck(:name)

        if resource_types.include?('video')
          t('resource_types.video')
        else
          t('resource_types.resource')
        end
      end
    end
  end
end
