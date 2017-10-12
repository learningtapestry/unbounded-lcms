# frozen_string_literal: true

class DocumentBundle < ActiveRecord::Base
  CATEGORIES = %w(full tm sm).freeze

  belongs_to :resource

  mount_uploader :file, DocumentBundleUploader

  validates :resource, :category, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  def self.update_bundle(resource, category = :full)
    zip_path = LessonsBundler.new(resource, category).bundle
    return unless zip_path && File.exist?(zip_path)

    begin
      doc_bundle = find_or_create_by(resource: resource, category: category)

      File.open(zip_path) do |f|
        doc_bundle.file = f
        doc_bundle.save!
      end
    ensure
      FileUtils.rm(zip_path)
    end
  end
end
