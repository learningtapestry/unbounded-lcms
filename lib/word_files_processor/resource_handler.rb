module WordFilesProcessor
  class ResourceHandler
    include Tools

    attr_reader :file, :context

    def initialize(file, context)
      @file = file
      @context = context.to_h.merge(@file.filename_fragments)
      find!
    end

    def breadcrumbs
      @breadcrumb_short_title ||= begin
        breadcrumb = []
        breadcrumb << subject_abbrv
        breadcrumb << "G#{context[:grade]}"  if context[:grade]
        breadcrumb << "M#{context[:module]}" if context[:module]
        breadcrumb << "U#{context[:unit]}"   if context[:unit]
        breadcrumb << "L#{context[:lesson]}" if context[:lesson]
        breadcrumb.join(' / ')
      end
    end

    def subject_abbrv
      (/math/i).match(context[:subject]) ? 'MA' : 'EL'
    end

    def find_by_breadcrumbs
      Curriculum.trees.find_by(breadcrumb_short_title: breadcrumbs)
    end

    def find_by_introspection
      # unnecessary for now. Look on https://github.com/learningtapestry/unbounded/issues/411 for more info on this
      nil
    end

    def find!
      @curriculum = find_by_breadcrumbs || find_by_introspection
      @resource = @curriculum.resource
    end

    def attrs
      {
        curriculum_id:  @curriculum.id,
        resource_id:    @resource.id,
        resource_title: @resource.title,
        breadcrumbs:    breadcrumbs,
        filename:       @file.basename,
        dir:            @file.filepath.dirname
      }
    end

    def report(extras)
      csv attrs.merge(extras)
    end

    def create_db_assoc!
      # @resource.downloads << file.filepath.open
      # @resource.save!
    end

    def remove_all!
      # Disabled for now!
      # @resource.downloads = []
      # @resource.save!
    end
  end
end
