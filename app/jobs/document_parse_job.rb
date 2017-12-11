# frozen_string_literal: true

class DocumentParseJob < ActiveJob::Base
  include GoogleCredentials
  include ResqueJob
  include RetryDelayed

  queue_as :default

  def perform(entry, auth_id, options = {})
    @credentials = google_credentials(auth_id)

    link = if entry.is_a?(Document)
             @document = entry
             reimport_materials if options[:reimport_materials].present?
             @document.file_url
           else
             entry
           end

    form = DocumentForm.new({ link: link }, credentials)
    res = if form.save
            { ok: true, link: link, model: form.document }
          else
            { ok: false, link: link, errors: form.errors[:link] }
          end
    store_result res
  end

  private

  attr_reader :credentials, :document

  def reimport_materials
    document.materials.each do |material|
      MaterialForm.new({ link: material.file_url }, credentials).save
    end
  end
end
