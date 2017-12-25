# frozen_string_literal: true

class DocumentParseJob < ActiveJob::Base
  include GoogleCredentials
  include ResqueJob
  include RetryDelayed

  queue_as :default

  def perform(entry, auth_id, options = {})
    @credentials = google_credentials(auth_id)

    if entry.is_a?(Document)
      @document = entry
      reimport_materials if options[:reimport_materials].present?
      reimport_document(@document.file_url) if result.nil?
    else
      reimport_document entry
    end

    store_result result

    @document.update(reimported: false) unless result[:ok]
  end

  private

  attr_reader :credentials, :document, :result

  def reimport_document(link)
    form = DocumentForm.new({ link: link }, credentials, import_retry: true)
    @result = if form.save
                { ok: true, link: link, model: form.document }
              else
                { ok: false, link: link, errors: form.errors[:link] }
              end
  end

  def reimport_materials
    document.materials.each do |material|
      link = material.file_url
      form = MaterialForm.new({ link: link, source_type: material.source_type }, credentials, import_retry: true)
      next if form.save

      error_msg = %(Material error (<a href="#{link}">source</a>): #{form.errors[:link]})
      @result = { ok: false, link: link, errors: [error_msg] }
      break
    end
  end
end
