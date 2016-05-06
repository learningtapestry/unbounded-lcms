if false
  content_guides = YAML.load_file('./db/seeds/development/content_guides.yml')

  content_guides.each do |hash|
    content_guide = ContentGuide.find_or_initialize_by(file_id: hash[:file_id])
    content_guide.update!(hash)
  end
end
