module PDFDownloadable
  extend ActiveSupport::Concern

  def pdf_title
    base_title = title.gsub(/[^[[:alnum:]]]/, '_').gsub(/_+/, '_')
    "#{base_title}_v#{version}"
  end

  def pdf_version
    v = pdf.url.split('_').last
    v[1..-1].to_i if v.start_with?('v')
  end

  def pdf_refresh?
    pdf.blank? || pdf_version != version
  end

  # If PDF is stale, refresh it using a remote URL
  def pdf_refresh!(new_pdf_url)
    return unless pdf_refresh?
    self.remote_pdf_url = new_pdf_url
    save!
  end
end
