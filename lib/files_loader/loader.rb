module FilesLoader
  class Loader
    attr_reader :basedir, :contexts

    def initialize(basedir, extension_name=nil)
      @basedir = basedir
      @contexts = []
      @extension_name = extension_name
    end

    # get module specific extension
    def extension
      @extension ||= Extensions.build(@extension_name, self) if @extension_name
    end

    def load!
      csv :headers

      files { |fname| @contexts << build_context(fname) }

      # extension hook
      extension.before_process if extension

      @contexts.each { |ctx| process ctx }
    end

    # for all files matching an extension, call a block
    def files(extension='docx', &blk)
      pattern = File.join(basedir, "**/*.#{extension}")
      Dir.glob(pattern).each { |f| yield f }
    end

    def process(context)
      rh = ResourceHandler.new(context, basedir)
      csv context.merge(rh.attrs).merge(action: 'add')
      rh.create_association
    end

    def build_context(fname)
      relpath = fname.sub(basedir + '/', '') # relative path

      # extract context info from the file relpath
      ctx = Hash[*[
          :subject, :grade, :unit, :module, :lesson, :topic, :level, :category
        ].map { |k| [k, send(:"extract_#{k}", relpath)] }.flatten
      ].compact

      filename_old = relpath.split('/').last
      dir = relpath.split('/')[0...-1].join('/')
      filename = new_filename(ctx)
      new_path = File.join(basedir, dir, filename)

      # rename files which changed names
      File.rename(fname, new_path) if filename != filename_old

      extras = {
        filename: filename,
        filename_old: (filename != filename_old ? filename_old : nil),
        dir: dir,
      }.compact

      ctx.merge extras
    end

    def extract_level(path)
      level = :lesson if path.match(/Lesson Level/i)
      level = :unit if path.match(/Unit Level/i)
      level = :module if path.match(/Module Level/i)
      level
    end

    def extract_subject(path)
      path.match(/math/i) ? 'math' : 'ela'
    end

    def extract_grade(path)
      # grade-2 OR Grade 2
      grade = path.match(/grade[\s|\-](\d+)/i).try(:[], 1)
      # ela-g12-m2-unit-2
      grade = path.match(/\-g(\d+)\-/i).try(:[], 1) unless grade.present?
      grade
    end

    def extract_unit(path)
      #unit-2 OR Unit 2
      path.match(/unit[\s|\-](\d+)/i).try(:[], 1)
    end

    def extract_module(path)
      # module-3 OR Module 3
      mod = path.match(/module[\s|\-](\d+)/i).try(:[], 1)
      # ela-g12-m2-unit-2
      mod = path.match(/\-m(\d+)\-/i).try(:[], 1) unless mod.present?
      # ELA Grade 12 Literary Criticism Module_ Module Performance Assessment.docx
      mod = 'LC' if mod.blank? && path.match(/Literary Criticism Module/i)
      # ELA Grade 12 Extension Module_ Performance Tool.docx
      mod = 'EM' if mod.blank? && path.match(/Extension Module/i)
      # ela-grade-12.ext.l1.docx
      mod = 'EM' if mod.blank? && path.match(/\.ext\.l\d+\.(docx|doc|pdf)/)
      mod
    end

    def extract_lesson(path)
      # lesson-3 OR Lesson 3
      les = path.match(/lesson[\s|\-](\d+)/i).try(:[], 1)
      # something awesome_3.W.3.l5.docx
      les = path.match(/\.l(\d+)\.(docx|doc|pdf)/i).try(:[], 1) unless les.present?
      les
    end

    def extract_topic(path)
      # , Unit 3 - Unit Overview.docx
      topic = path.match(/\, Unit \d+ \- (.*)\.(docx|doc|pdf)/i).try(:[], 1)
      # Module 2 - Performance Assessment Rubric and Checklist.docx
      topic = path.match(/ Module \d+ \- (.*)\.(docx|doc|pdf)/i).try(:[], 1) unless topic.present?
      # -lesson-3-final-lesson.docx
      topic = path.match(/\-lesson\-\d+\-(.*)\.(docx|doc|pdf)/i).try(:[], 1).try(:titleize) unless topic.present?
      # something awesome_3.W.3.l5.docx
      topic = path.match(/(.*)_\d+\.[\d|\w]+\.\d+\.l\d+\.(docx|doc|pdf)/i).try(:[], 1) unless topic.present?
      # ELA Grade 12 Literary Criticism Module_ Module Performance Assessment
      topic = path.match(/Literary Criticism Module_ (.*)\.(docx|doc|pdf)/i).try(:[], 1) unless topic.present?
      # ELA Grade 12 Extension Module_ Performance Tool
      topic = path.match(/Extension Module_ (.*)\.(docx|doc|pdf)/i).try(:[], 1) unless topic.present?

      topic.present? ? topic : nil
    end

    def extract_category(path)
      category = 'rubrics_and_tools' if path.match(/Rubrics and Tools\//i)
      category = 'texts' if path.match(/Texts\//i)
      category
    end

    def new_filename(ctx, extension='.docx')
      # Ela Grade 12 Module 2, Unit 1, Lesson 3 - Topic.docx
      pieces = []
      pieces << (ctx[:subject] == 'ela' ? 'ELA ' : 'Math ')
      pieces << "Grade #{ctx[:grade]} "    if ctx[:grade]
      if ctx[:module]
        if ctx[:module] == 'LC'
          # Ela Grade 12 Literary Criticism Module, Unit 1, Lesson 3 - Topic.docx
          pieces << 'Literary Criticism Module'
        elsif ctx[:module] == 'EM'
          # Ela Grade 12 Extension Module, Lesson 3 - Topic.docx
          pieces << 'Extension Module'
        else
          pieces << "Module #{ctx[:module]}"
        end
      end
      pieces << ", Unit #{ctx[:unit]}"     if ctx[:unit]
      pieces << ", Lesson #{ctx[:lesson]}" if ctx[:lesson]
      pieces << " - #{ctx[:topic]}" if ctx[:topic]
      pieces.join('').strip + extension
    end

    def csv_fields
      [ :curriculum_id, :resource_id, :resource_title, :category, :breadcrumbs,
        :action, :dir, :filename_old, :filename ]
    end

    def csv(row)
      entries = (row == :headers) ? csv_fields.map(&:to_s) : csv_fields.map { |key| row[key].to_s }
      puts entries.map { |v| "\"#{v}\"" }.join(',')
    end
  end
end
