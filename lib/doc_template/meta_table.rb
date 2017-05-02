module DocTemplate
  class MetaTable
    def self.parse(fragment)
      table = new
      table.parse(fragment)
    end

    def parse(fragment)
      binding.pry
      table = fragment.at_css('table')
      return self unless table

      table.search('br').each { |br| br.replace("\n") }
      @data = table.css('tr').map do |tr|
        key, value = tr.css('td').map(&:content).map(&:strip)
      end

      table.remove
      self
    end

    def render
      @data || {}
    end
  end
end

