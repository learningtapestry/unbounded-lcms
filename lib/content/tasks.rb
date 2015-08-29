require 'content/models'

namespace :content do

  task boot: [:environment]

  desc 'Process fresh EngageNY documents to a conformed format'
  task conform_engageny: [:boot] do
    require 'content/conformers/engageny_conformer'

    Content::Models::SourceDocument
    .unconformed
    .engageny
    .order(id: :asc).find_in_batches(batch_size: 10) do |batch|
      Content::Models::Document.transaction do
        batch.each do |source_doc|
           doc = Content::Conformers::EngagenyConformer.new(source_doc.document).conform!
           puts "Conformed #{doc.id}."
        end
      end
    end
  end

  desc 'Process fresh LRMI documents to a conformed format'
  task conform_lrmi: [:boot] do
    require 'content/conformers/lr_lrmi_conformer'

    Content::Models::LrDocument
    .joins(:source_document)
    .where('source_documents.conformed_at' => nil)
    .where_schema(:lrmi)
    .order(id: :asc).find_in_batches(batch_size: 10) do |batch|
      Content::Models::Document.transaction do
        batch.each do |lr_document|
           doc = Content::Conformers::LrLrmiConformer.new(lr_document).conform!
           puts "Conformed #{doc.id}."
        end
      end
    end
  end

  desc 'Process fresh documents to a conformed format'
  task conform: [:conform_engageny, :conform_lrmi]

  desc 'Merge fresh conformed documents into learning objects'
  task merge: [:boot] do
    require 'content/merger'

    Content::Models::Document
    .unmerged
    .order(id: :asc)
    .find_each(batch_size: 1) do |doc|
       lobject = Content::Merger.find_candidates_and_merge(doc)
       puts "Merged conformed doc \##{doc.id} into object \##{lobject.id}."
    end
  end

  desc 'Conform, merge and index raw documents'
  task process: [:conform, :merge]

  desc 'Parse Learning Registry documents for further processing'
  task parse: [:boot] do
    require 'content/envelope'

    last_parsed = Content::Models::LrDocument.where(parsed: true).order(id: :desc).limit(1).first
    start_at = last_parsed.id + 1

    puts "Starting from id #{start_at}."

    Content::Models::LrDocument.find_in_batches(batch_size: 300, start: start_at) do |group|
      Content::Models::LrDocument.transaction do
        group.each do |lr_doc|
          parsed_doc = Content::Format.parse(lr_doc.raw_data)
          if parsed_doc
            case parsed_doc.format
            when :json then lr_doc.resource_data_json = parsed_doc.raw
            when :xml then lr_doc.resource_data_xml = parsed_doc.raw
            else lr_doc.resource_data_string = parsed_doc.raw
            end
            puts "Saving doc #{lr_doc.id}."
            lr_doc.parsed = true
            lr_doc.save
          else
            lr_doc.resource_data_json = nil
            lr_doc.resource_data_xml = nil
            lr_doc.resource_data_string = nil
            lr_doc.parsed = false
            puts "Doc #{lr_doc.id} could not be parsed."
            lr_doc.save
          end
        end
      end
    end
  end

  desc 'Remove deleted Learning Registry documents from the LOR'
  task clean_deletes: [:boot] do
    require 'json'

    Content::Models::LrDocument.find_in_batches(batch_size: 500) do |group|
      Content::Models::LrDocument.transaction do
        group.each do |lr_doc|
          in_json = JSON.parse(lr_doc.raw_data)
          if in_json['replaces'] and in_json['resource_data'].nil?
            lr_doc.delete
            puts "Deleted #{lr_doc.id}."
          end
        end
      end
    end
  end

  desc 'Check URL status for Learning Objects'
  task check_urls: [:boot] do
    require 'content/enrichers/url_status_checker'

    outputter = Log4r::RollingFileOutputter.new(:check_urls,
      filename: File.join(LT.env.log_path, 'check_urls.log'),
      maxsize: 10*1024*1024,
      trunc: false
    )
    LT.env.logger.add(outputter)

    puts "Checking status for URLs."
    Content::Enrichers::UrlStatusChecker.check_statuses

    LT.env.logger.remove(:check_urls)
  end

  desc 'Import EngageNY resources'
  task import_engageny_documents: [:boot] do
    require 'content/importers/engageny_importer'
    Content::Importers::EngagenyImporter.import_all_nodes
  end

  desc 'Import EngageNY collections and related resources'
  task import_engageny_collections: [:boot] do
    require 'content/importers/engageny_importer'
    Content::Importers::EngagenyImporter.import_all_collections_and_related
  end

  desc 'Import all EngageNY data'
  task import_engageny: [:import_engageny_documents, :process, :import_engageny_collections]

  desc 'Import LR documents from a CSV file'
  task import_csv: [:boot] do
    require 'content/importers/csv_importer'
    Content::Importers::CsvImporter.import_csv(ENV['file'], ENV['format'])
  end

  namespace :elasticsearch do

    desc 'Create ElasticSearch index definitions for searchable models'
    task create_indeces: [:boot] do
      Content::Models::Searchable.searchables.each { |s| s.__elasticsearch__.create_index! }
    end

    desc 'Recreate the ElasticSearch database for searchable models'
    task full_reindex: [:boot] do
      Content::Models::Searchable.searchables.each do |s|
        s.__elasticsearch__.create_index!(force: true)
        s.__elasticsearch__.refresh_index!
        s.index! do |response|
          ids = Array.wrap(response['items']).map { |item| item['index']['_id'] }
          puts "Imported #{s.to_s} \##{ids.first}-#{ids.last}."
        end
      end
    end

    desc 'Index fresh searchable models'
    task index: [:create_indeces] do
      Content::Models::Searchable.searchables.each do |s|
        s.index!(scope: :not_indexed) do |response|
          ids = Array.wrap(response['items']).map { |item| item['index']['_id'] }
          puts "Imported #{s.to_s} \##{ids.first}-#{ids.last}."
        end
      end
    end
  end

end
