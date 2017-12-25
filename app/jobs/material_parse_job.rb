# frozen_string_literal: true

class MaterialParseJob < ActiveJob::Base
  include GoogleCredentials
  include ResqueJob

  queue_as :default

  def perform(entry, auth_id)
    link = entry.is_a?(Material) ? entry.file_url : entry
    credentials = google_credentials(auth_id)
    form = MaterialForm.new({ link: link }, credentials, import_retry: true)
    res = if form.save
            { ok: true, link: link, model: form.material }
          else
            { ok: false, link: link, errors: form.errors[:link] }
          end
    store_result res
  end
end
