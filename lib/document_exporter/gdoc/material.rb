# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    class Material < Gdoc::Base
      def export
        @options[:subfolders] = [DocumentExporter::Gdoc::StudentMaterial::FOLDER_NAME] if student?
        @options[:subfolders] = [DocumentExporter::Gdoc::TeacherMaterial::FOLDER_NAME] if teacher?
        unless @options.key?(:subfolders)
          Rails.logger.warn "Material belongs neither to teachers nor to students: #{document.id}"
          @options[:subfolders] = ['Materials']
        end
        super
      end

      private

      def student?
        ::Material.where(id: document.id).where_metadata_any_of(config_for(:student)).present?
      end

      def teacher?
        ::Material.where(id: document.id).where_metadata_any_of(config_for(:teacher)).present?
      end

      def template_path(name)
        File.join('documents', 'gdoc', 'materials', name)
      end
    end
  end
end
