module WordFilesProcessor
  class File
    include Tools

    attr_reader :filepath

    def initialize(filepath)
      fail ArgumentError, "Pathname expected, #{filepath.class.name} given" unless filepath.is_a? Pathname
      @filepath = filepath
    end

    # @return [String]
    def basename
      filepath.basename.to_s
    end

    def template
      klass.templates.detect do |template|
        template[:regex].match(basename)
      end.presence
    end

    # @return [Hash]
    def filename_fragments
      return {} unless template
      template[:regex].match(basename)
      hash_of_named_captures($~)
    end

    # @param [Hash] extra_fields
    def recommended_filename(extra_fields: {})
      return "" unless template
      template[:format] % filename_fragments.merge(extra_fields)
    end

    def klass
      self.class
    end

    def self.templates
      [
        {
          regex: /(?<subject>math|ela) Grade (?<grade>[0-9]+) Module (?<module>[0-9]+[A-Z]*)(, Unit (?<unit>[0-9]+))? \- (?<topic>.*)\.(?<ext>docx|doc|pdf)/i,
          format: "%{subject} Grade %{grade} Module %{module} - %{topic}.%{ext}",
        },
        {
          regex: /(?<subject>math|ela)-(?<grade>[0-9]+)\.(?<module>[0-9]+[A-Z]*)\.(?<unit>[0-9]+)\.l(?<lesson>[0-9]{1,2})\.(?<ext>docx|doc|pdf)/i,
          format: "%{subject} Grade %{grade} Module %{module}, Unit %{unit}, Lesson %{lesson}.%{ext}",
        },
        {
          regex: /(?<topic>.*)_(?<grade>[0-9]+)\.(?<module>[0-9]+[A-Z]*)\.(?<unit>[0-9]+)\.l(?<lesson>[0-9]{1,2})\.(?<ext>docx|doc|pdf)/i,
          format: "%{subject} Grade %{grade} Module %{module}, Unit %{unit}, Lesson %{lesson} - %{topic}.%{ext}",
        },
      ]
    end
  end
end
