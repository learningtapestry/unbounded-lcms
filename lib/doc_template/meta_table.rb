module DocTemplate
  class MetaTable
    HEADER_LABEL = 'document-metadata'

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      # get the very first table available in the page
      table = fragment.at_css('table')
      return self unless table

      table_header = table.at_css('tr > td')
      return self unless table_header.content.strip == HEADER_LABEL

      table_header.remove

      table.search('br').each { |br| br.replace("\n") }
      data_collection = table.css('tr').map do |tr|
        tr.css('td').map(&:content).map(&:strip)
      end.compact

      @data = data_collection.select(&:present?).to_h

      table.remove
      self
    end

    def render
      @data || {}
    end
  end
end

