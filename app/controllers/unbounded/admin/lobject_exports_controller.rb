require 'content/exporters/csv_exporter'

module Unbounded
  module Admin
    class LobjectExportsController < AdminController
      include Content::Exporters

      def new
      end

      def create
        exporter = CsvExporter.new(params[:grades])
        csv_data = exporter.export
        send_data csv_data, disposition: 'attachment', filename: exporter.filename, type: 'text/csv'
      end
    end
  end
end
