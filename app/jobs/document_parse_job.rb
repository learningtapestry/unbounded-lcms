# frozen_string_literal: true

class DocumentParseJob < ActiveJob::Base
  include ResqueJob
  include RetryDelayed

  queue_as :default

  def perform(document, auth_id, options = {})
    @credentials = google_credentials(auth_id)
    @document = document

    reimport_materials if options[:reimport_materials].present?

    link = @document.file_url
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

  def google_credentials(user_id)
    service = GoogleAuthService.new(nil)
    fake_request = OpenStruct.new(session: {})
    service.authorizer.get_credentials(user_id, fake_request)
  end

  def reimport_materials
    document.materials.each do |material|
      MaterialForm.new({ link: material.file_url }, credentials).save
    end
  end
end
