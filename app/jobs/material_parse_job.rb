# frozen_string_literal: true

class MaterialParseJob < ActiveJob::Base
  include GoogleCredentials
  include ResqueJob

  queue_as :default

  def perform(entry, auth_id)
    credentials = google_credentials(auth_id)

    attrs = attributes_for entry
    form = MaterialForm.new(attrs, credentials, import_retry: true)
    res = if form.save
            { ok: true, link: attrs[:link], model: form.material }
          else
            { ok: false, link: attrs[:link], errors: form.errors[:link] }
          end
    store_result res
  end

  private

  def attributes_for(entry)
    {}.tap do |data|
      data[:link] = entry.is_a?(Material) ? entry.file_url : entry
      data[:source_type] = entry.source_type if entry.is_a?(Material)
    end
  end
end
