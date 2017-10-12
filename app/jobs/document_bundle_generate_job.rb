# frozen_string_literal: true

class DocumentBundleGenerateJob < ActiveJob::Base
  extend ResqueJob

  queue_as :low

  def perform(resource, options)
    category = options[:category]
    unit = resource.unit? ? resource : resource.parents.detect(&:unit?)

    DocumentBundle.update_bundle(unit, category) if unit
  end
end
