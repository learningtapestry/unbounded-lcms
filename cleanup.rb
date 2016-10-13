


def find_topic(s)
  (/topic\s+([A-Z]{1})/i).match(s)[1] rescue nil
end

def find_unit(s)
  (/unit\s+([0-9]{1,2})/i).match(s)[1] rescue nil
end

def find_grade(s)
  (/grade\s+([0-9]{1,2})/i).match(s)[1] rescue nil
end

def find_module(s)
  (/module\s+([0-9]+[A-D]{0,1})/i).match(s)[1] rescue nil
end

def find_subject(s)
  (/(Math|ELA)/).match(s)[0] rescue nil
end

def find_lesson(s)
  (/lesson\s+([0-9]{1,3})/).match(s)[0] rescue nil
end

def subdirs(dir)
  dirs = Dir.entries(dir).collect do |entry|
    next if (entry =='.' || entry == '..')
    fullpath = File.join(dir, entry)
    File.directory?(fullpath) ? fullpath : nil
  end.compact
  dirs
end

def subfiles(dir)
  files = Dir.entries(dir).collect do |entry|
    next if (entry =='.' || entry == '..')
    fullpath = File.join(dir, entry)
    File.file?(fullpath) ? fullpath : nil
  end.compact
  files
end


def detect_level(text)
  {
    "Module Level Downloads" => :module,
    "Unit Level Downloads"   => :unit,
    "Lesson Level Downloads" => :lesson,
  }.detect { |k,v| text.include?(k) }.try(:last)
end


def extract_context(text)
  {
    subject: find_subject(text),
    grade:   find_grade(text),
    module:  find_module(text),
    unit:    find_unit(text),
    lesson:  find_lesson(text),
    topic:   find_topic(text),
  }.delete_if { |key, value| value.blank? }
end


def rename_lesson_files(directory)
  subfiles(directory).each do |file|
    basename = File.basename(file)
    re = /(?<subject>math|ela)-(?<grade>[0-9]+)\.(?<module>[0-9]+[A-Z]*)\.(?<unit>[0-9]+)\.l(?<lesson>[0-9]{1,2})\.(?<ext>docx|doc|pdf)/i
    if m = re.match(basename)
      p = Hash[$~.names.collect{|x| [x.to_sym, $~[x]]}] # Named captures as Hash
      new_filename = "" \
        + "#{p[:subject].titleize} Grade #{p[:grade]} " \
        + "Module #{p[:module].upcase}, " \
        + "Unit #{p[:unit]}, Lesson #{p[:lesson]}.#{p[:ext]}"
      puts "---- rename #{basename} to '#{new_filename}'"
      puts "---- attach '#{new_filename}' to lesson #{p[:lesson]}"
    else
      puts "---- not match: #{basename}"
    end
  end
end

def rename_lesson_rubric_files(directory, context:)
  subfiles(directory).each do |file|
    basename = File.basename(file)
    re = /(?<topic>.*)_(?<grade>[0-9]+)\.(?<module>[0-9]+[A-Z]*)\.(?<unit>[0-9]+)\.l(?<lesson>[0-9]{1,2})\.(?<ext>docx|doc|pdf)/i
    if m = re.match(basename)
      p = Hash[$~.names.collect{|x| [x.to_sym, $~[x]]}] # Named captures as Hash
      new_filename = "" \
        + "#{context[:subject]} Grade #{p[:grade]} " \
        + "Module #{p[:module].upcase}, " \
        + "Unit #{p[:unit]}, Lesson #{p[:lesson]} - #{p[:topic]}.#{p[:ext]}"
      puts "---- rename #{basename} to '#{new_filename}'"
      puts "---- attach '#{new_filename}' to lesson #{p[:lesson]}"
    else
      puts "---- not match: #{basename}"
    end
  end
end
def add_lessons_files(directory)
  subfiles(directory).each do |file|
    basename = File.basename(file)
      puts "---- #{basename}"
  end
end

def recursively_dig(directory, context: {})
  subdirs(directory).each do |subdir|
    basename = File.basename(subdir)
    puts "-- DIR: #{subdir}"
    #puts "--- dir: #{basename}"
    #puts "--- context: #{context.inspect}"
    new_context = extract_context(basename)
    new_context[:level] = detect_level(subdir)
    context.merge!(new_context)
    puts "-- CONTEXT: #{context.inspect}"
    case context[:level]
    when :module
      if basename.ends_with? "Rubrics and Tools"
        puts "--- Add the following files to module #{context[:module]} under 'Rubrics and Tools' category:"
        add_lessons_files(subdir)
      else
        puts "--- Add the following files to module #{context[:module]}:"
        add_lessons_files(subdir)
      end
    when :lesson
      if basename == "Lessons"
        puts "--- Rename, then add the folloing files to corresponding lessons:"
        rename_lesson_files(subdir)
      end
      if basename == "Rubrics and Tools"
        puts "--- Rename, then add the following files to the corresponding lessons under 'Rubrics and tools' category:"
        rename_lesson_rubric_files(subdir, context: context)
      end
    when :unit
      puts "--- Remove ALL files attached to unit #{context[:unit]}"
      puts "--- Add the following files to unit #{context[:unit]}"
      add_lessons_files(subdir)
    end
    recursively_dig(subdir, context: context)
  end
end


rootdir = Rails.root + '.gdrive_test_files'


puts "="*100
recursively_dig(rootdir)
"ela-11.3.1.l6.docx"
