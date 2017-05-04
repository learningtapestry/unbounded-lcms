module DocTemplate
  class MetaTable
    HEADER_LABEL = 'document-metadata'.freeze

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      # get the metadata table
      table = fragment.at_xpath("table//*[contains(., '#{HEADER_LABEL}')]")
      return self unless table

      table.search('br').each { |br| br.replace("\n") }
      @data = {}.tap do |result|
                table.xpath('.//tr[position() > 1]').each do |tr|
                  key = tr.at_xpath('./td[1]').text.strip.downcase
                  next if key.blank?
                  result[key] = tr.at_xpath('./td[2]').text.strip
                end
              end

      table.remove
      self
    end

    def data
      @data || {}
    end
  end
end

