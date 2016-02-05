class Admin::CurriculumExportsController < Admin::AdminController
  def new
  end

  def create
    exporter = CurriculumExporter.new(params[:grades])
    excel_data = exporter.export
    send_data excel_data, disposition: 'attachment', filename: exporter.filename, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end
end
