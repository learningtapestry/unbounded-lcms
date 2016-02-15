class GoogleDocPresenter < SimpleDelegator
  Heading = Struct.new(:id, :level, :text)

  def content
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
