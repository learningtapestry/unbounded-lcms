module DocTemplate
  class AgendaTable
    HEADER_LABEL = '[agenda]'
    METADATA_HEADER_LABEL = '[agenda]'

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      table = fragment.at_xpath("table[.//*[contains(text(), '#{HEADER_LABEL}')]]")
      return self unless table

      # retain new lines
      table.search('br').each { |br| br.replace("\n") }
      # skip the header
      @data = []

      table.xpath('./*/tr[position() > 1]').each_with_index do |tr, index|
        # take the only two fields
        metadata, metacognition = tr.xpath('./td')
        # identify the referencing tag
        tag_name, tag_value = FULL_TAG.match(metacognition.content).captures

        element = {
          id: tag_value.parameterize,
          metadata: render_metadata(metadata),
          metacognition: render_metacognition(metacognition),
          children: []
        }

        # the group tags are parents and the following
        # sections after each group are children of that group
        if tag_name.downcase.include?('group')
          @parent_index = index
          @data << element
        else
          @data[@parent_index][:children] << element
        end
      end

      table.remove
      self
    end

    def data
      @data
    end

    private

    def render_metadata(fragment)
      table = fragment.at_xpath("table[.//*[contains(text(), '#{METADATA_HEADER_LABEL}')]]")
      return {} unless table

      data_collection = table.css('tr').map do |tr|
        tr.xpath('./td').map(&:content).map(&:strip)
      end.compact

      data_collection.select(&:present?).to_h
    end

    def render_metacognition(fragment)
      # remove the tag
      fragment.at_xpath(ROOT_XPATH + STARTTAG_XPATH).parent.remove
      { content: fragment.content }
    end
  end
end
