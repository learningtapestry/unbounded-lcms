require 'content/importers/csv_importer'

class CsvImportJob < ActiveJob::Base
  queue_as :default
 
  def perform(path, replace)
    Content::Importers::CsvImporter.import(path, replace: replace)
  end
end
