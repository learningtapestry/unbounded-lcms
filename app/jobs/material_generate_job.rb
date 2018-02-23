# frozen_string_literal: true

class MaterialGenerateJob < ActiveJob::Base
  include ResqueJob

  queue_as :default

  def perform(material, document)
    material.material_parts.default.each { |p| p.update!(content: EmbedEquations.call(p.content)) } if document.math?

    MaterialGeneratePDFJob.perform_later(material, document)
    MaterialGenerateGdocJob.perform_later(material, document) unless material.pdf?
  end
end
