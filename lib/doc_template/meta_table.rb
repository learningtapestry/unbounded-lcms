module DocTemplate
  class MetaTable
    HEADER_LABEL = 'document-metadata'

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      # get the metadata table
      table = fragment.at_xpath("table[.//*[contains(text(), '#{HEADER_LABEL}')]]")
      return self unless table

      table.at_css('tr > td').remove

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

