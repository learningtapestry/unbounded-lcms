require 'wicked_pdf'

WickedPdf.config = {
  wkhtmltopdf: ENV['WKHTMLTOPDF_PATH']
}
