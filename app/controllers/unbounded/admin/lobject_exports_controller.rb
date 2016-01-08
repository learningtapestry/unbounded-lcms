require 'content/exporters/excel_exporter'

module Unbounded
  module Admin
    class LobjectExportsController < AdminController
      include Content::Exporters

      def new
      end

      def create
        exporter = ExcelExporter.new(params[:grades])
        excel_data = exporter.export
        send_data excel_data, disposition: 'attachment', filename: exporter.filename, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end
  end
end
