# TODO: Need to refactor - now it's using only in ContentGuide
module PDFDownloadable
  extend ActiveSupport::Concern

  def pdf_title
    base_title = title.gsub(/[^[[:alnum:]]]/, '_').gsub(/_+/, '_')
    "#{base_title}_v#{version}"
  end

  # If PDF is stale, refresh it using a remote URL
  def pdf_refresh!(new_pdf_url)
    return if pdf_version == version
    self.remote_pdf_url = new_pdf_url
    save!
  end

  private

  def pdf_version
    return if pdf.blank?
    v = pdf.url.split('_').last
    v[1..-1].to_i if v.start_with?('v')
  end
end
