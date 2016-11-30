class GenericPresenter < ResourcePresenter
  def generic_title
    "#{subject.try(:upcase)} #{grades.try(:first).try(:name)}"
  end

  def type_name
    resource_type.humanize
  end

  def preview?
    downloads.any? { |d| d.main? && d.attachment_content_type == 'pdf' && RestClient.head(d.attachment_url) }
  rescue RestClient::ExceptionWithResponse
    false
  end

  def pdf_preview_download
    downloads.find { |d| d.main? && d.attachment_content_type == 'pdf' }
  end
end
