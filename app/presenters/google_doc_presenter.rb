class GoogleDocPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  Heading = Struct.new(:id, :level, :text)

  def content
    doc.css('a[href*="docs.google.com/document/d/"]').each do |a|
      file_id = GoogleDoc.file_id_from_url(a[:href])
      if (google_doc = GoogleDoc.find_by_file_id(file_id))
        a[:href] = google_doc_path(google_doc)
      end
    end
    doc.to_s.html_safe
  end

  def content_for_pdf
    path2public = Rails.root.join('public')
    doc.css('img[src^="/uploads"]').each do |img|
      img[:src] = "file://#{path2public}#{img[:src]}"
    end
    doc.to_s.html_safe
  end

  def headings
    headings =
      doc.css('h1, h2, h3, h4, h5, h6').each_with_index.map do |h, i|
        id = "heading_#{i}"
        level = h.name[/\d/].to_i
        text = h.text.chomp.strip

        h[:id] = id
        
        Heading.new(id, level, text)
      end

    min_level = headings.map(&:level).minmax.first
    headings.each { |h| h.level -= min_level }
    headings
  end
end
