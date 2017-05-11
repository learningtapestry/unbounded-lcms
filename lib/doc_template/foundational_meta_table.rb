module DocTemplate
  class FoundationalMetaTable
    HEADER_LABEL = 'foundational-metadata'.freeze

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      # get the table
      table = fragment.at_xpath("table//*[contains(., '#{HEADER_LABEL}')]")
      return self unless table

      table.remove
      self
    end
  end
end

