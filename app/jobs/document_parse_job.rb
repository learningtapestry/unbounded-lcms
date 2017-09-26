# frozen_string_literal: true

class DocumentParseJob < ActiveJob::Base
  include ResqueJob

  queue_as :default

  def perform(link, auth_id)
    credentials = google_credentials(auth_id)
    form = DocumentForm.new({ link: link }, credentials)
    res = if form.save
            { ok: true, link: link, model: form.document }
          else
            { ok: false, link: link, errors: form.errors[:link] }
          end
    store_result res
  end

  private

  def google_credentials(user_id)
    service = GoogleAuthService.new(nil)
    fake_request = OpenStruct.new(session: {})
    service.authorizer.get_credentials(user_id, fake_request)
  end
end
