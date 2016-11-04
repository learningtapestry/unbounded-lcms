module FilesLoader
  class ResourceHandler
    attr_reader :context, :basedir

    def initialize(context, basedir)
      @context = context
      @basedir = basedir
      find!
    end

    def find!
      @curriculum = find_by_breadcrumbs || find_by_introspection
      @resource = @curriculum.resource
    end

    def find_by_breadcrumbs
      Curriculum.trees.find_by(breadcrumb_short_title: breadcrumbs)
    end

    def find_by_introspection
      # Grade
      curr = Curriculum.grades
                       .where_grade("grade #{context[:grade]}")
                       .where_subject(context.fetch(:subject, 'ela').downcase)
                       .where(parent: nil).first

      # Module
      if context[:module]
        mod = curr.children.select do |c|
          c.resource.short_title =~ /^module #{context[:module]}$/
        end.first.try(:item)
        curr = mod if mod
      end

      # Unit
      if context[:unit]
        unit = curr.children.select do |c|
          c.resource.short_title =~ /^unit #{context[:unit]}$/
        end.first.try(:item)
        curr = unit if unit
      end

      # Lesson
      if context[:lesson]
        lesson = curr.children.select do |c|
          c.resource.short_title =~ /^lesson #{context[:lesson]}$/
        end.first
        curr = lesson if lesson
      end

      curr
    end

    def breadcrumbs
      @breadcrumb_short_title ||= begin
        breadcrumb = []
        breadcrumb << subject_abbrv
        breadcrumb << "G#{context[:grade]}"  if context[:grade]
        if context[:module]
          # MX if X is a number, else use the module itself (e.g: LC)
          breadcrumb << (context[:module].match(/^\d+$/) ? "M#{context[:module]}" : context[:module])
        end
        breadcrumb << "U#{context[:unit]}"   if context[:unit]
        breadcrumb << "L#{context[:lesson]}" if context[:lesson]
        breadcrumb.join(' / ')
      end
    end

    def subject_abbrv
      (/math/i).match(context[:subject]) ? 'MA' : 'EL'
    end

    def create_association
      title = filename_without_ext context[:filename]

      [fpath, pdf_file].compact.each do |path|
        download = Download.create(file: File.open(path), title: title)
        @resource.downloads << download
        add_category_to_download(download)
      end

      @resource.save!
    end

    # full path
    def fpath
      File.join basedir, context[:dir], context[:filename]
    end

    def filename_without_ext(filename)
      # "something.bla" => "something"
      filename.gsub(/\.\w+$/, '') if filename
    end

    # Find the corresponding pdf file this file
    def pdf_file
      pdf = pdfs.select do |f|
        fname = Pathname.new(f).basename.to_s
        # The pdf name should be equal to either the new or the old filenames
        (filename_without_ext(fname) == filename_without_ext(context[:filename]) ||
         filename_without_ext(fname) == filename_without_ext(context[:filename_old]))
      end.first
    end

    # get all pdfs on the basedir
    def pdfs
      @@pdfs ||= begin
        pattern = File.join(basedir, "**/*.pdf")
        Dir.glob(pattern)
      end
    end

    def add_category_to_download(download)
      return unless context[:category].present?

      dr = ResourceDownload.find_by(download_id: download.id)
      dr.update_attributes download_category_id: DownloadCategory.find_by(name: context[:category]).id
    end

    def attrs
      {
        curriculum_id:  @curriculum.id,
        resource_id:    @resource.id,
        resource_title: @resource.title,
        breadcrumbs:    breadcrumbs,
      }
    end
  end
end
