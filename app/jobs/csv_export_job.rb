require 'content/importers/csv_importer'
require 'securerandom'

class CsvExportJob < ActiveJob::Base
  queue_as :default
 
  def perform(path)
    Content::Importers::CsvImporter.export(path)
  end
end
