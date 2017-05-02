module DocTemplate
  class MetaTable
    HEADER_LABEL = 'document-metadata'

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      table = fragment.at_css('table')
      return self unless table

      table.search('br').each { |br| br.replace("\n") }
      data_collection = table.css('tr').map do |tr|
        key, value = tr.css('td').map(&:content).map(&:strip)
        next if key == HEADER_LABEL
        [key, value]
      end.compact

      @data = data_collection.to_h

      table.remove
      self
    end

    def render
      @data || {}
    end
  end
end

