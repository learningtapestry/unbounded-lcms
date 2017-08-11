# frozen_string_literal: true

class MaterialGenerateJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  def perform(material, document)
    material.material_parts.default.each { |p| p.update!(content: EmbedEquations.call(p.content)) }

    MaterialGeneratePDFJob.perform_later material, document
    MaterialGenerateGdocJob.perform_later material, document
  end
end
