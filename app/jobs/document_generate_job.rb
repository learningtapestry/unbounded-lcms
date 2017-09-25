# frozen_string_literal: true

class DocumentGenerateJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  WAIT_FOR_JOBS = %w(MaterialGenerateJob MaterialGeneratePDFJob MaterialGenerateGdocJob).freeze

  def perform(document, check_queue: false)
    @document = document

    # Job has been queued from Material job
    if check_queue
      # Exit if any material is still generating
      return if materials_generating?
    else
      create_gdoc_folders
      # Queue all materials at the first time
      return queue_materials unless document.materials.blank?
    end

    # Got here: all materials have been re-generated
    document.document_parts.default.each { |p| p.update!(content: EmbedEquations.call(p.content)) }

    queue_documents
  end

  private

  attr_accessor :document

  def create_gdoc_folders
    DocumentExporter::Gdoc::Base.new(document).create_gdoc_folders("#{document.id}_v#{document.version}")
  end

  #
  # Checks if there are jobs queued or running for current document
  # and any of its materials
  #
  def materials_generating?
    document.materials.each do |material|
      queued = Resque.peek(queue_name, 0, 0)
                 .map { |job| job['args'].first }
                 .detect { |job| same_material?(job, material.id) }

      queued ||=
        Resque::Worker.working.map(&:job).detect do |job|
          next unless job.is_a?(Hash) && (args = job.dig 'payload', 'args').is_a?(Array)
          args.detect { |x| same_material?(x, material.id) }
        end

      return true if queued
    end
    false
  end

  def same_document?(job, type, klass)
    job['job_class'] == klass &&
      job['arguments'].first['_aj_globalid'].index("gid://content/Document/#{document.id}") &&
      job['arguments'].second['content_type'] == type
  end

  def same_material?(job, id)
    WAIT_FOR_JOBS.include?(job['job_class']) &&
      job['arguments'].first['_aj_globalid'].index("gid://content/Material/#{id}") &&
      job['arguments'].second['_aj_globalid'].index("gid://content/Document/#{document.id}")
  end

  def queue_documents
    DocumentGenerator::CONTENT_TYPES.each do |type|
      %w(DocumentGenerateGdocJob DocumentGeneratePdfJob).each do |klass|
        next if queued_or_running?(type, klass)
        klass.constantize.perform_later document, content_type: type
      end
    end
  end

  def queue_materials
    document.materials.each { |material| MaterialGenerateJob.perform_later(material, document) }
  end

  def queued_or_running?(type, klass)
    queued = Resque.peek(queue_name, 0, 0)
               .map { |job| job['args'].first }
               .detect { |job| same_document?(job, type, klass) }

    queued ||
      Resque::Worker.working.map(&:job).detect do |job|
        next unless job.is_a?(Hash) && (args = job.dig 'payload', 'args').is_a?(Array)
        args.detect { |x| same_document?(x, type, klass) }
      end
  end
end
