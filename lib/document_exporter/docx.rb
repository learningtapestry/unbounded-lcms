module DocumentExporter
  class Docx
    MIME_TYPE = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'.freeze

    attr_reader :data

    def export(content)
      @data = PandocRuby.convert content, from: :html, to: :docx
      self
    end
  end
end
