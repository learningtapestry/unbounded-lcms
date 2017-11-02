# frozen_string_literal: true

class MaterialGenerateJob < ActiveJob::Base
  include ResqueJob

  queue_as :default

  def perform(material, document)
    if document.math?
      material.material_parts.default.each { |p| p.update!(content: EmbedEquations.call(p.content)) }
    end

    MaterialGeneratePDFJob.perform_later(material, document)
    MaterialGenerateGdocJob.perform_later(material, document) unless material.pdf?
  end
end
