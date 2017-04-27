namespace :lesson do
  desc 'parses an html template'
  task :parse_file, [:file_path] => [:environment] do |t, args|
    input = File.open args[:file_path]
    html = DocTemplate::Template.parse(input).render
    File.open('output.html', 'w+') do |file|
      file << html
    end
  end
end
