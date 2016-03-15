namespace :es do

  desc 'Load index'
  task load: :environment do
    models = [ Resource ]

    models.each do |model|
      puts "Loading Index for: #{model.name}"
      model.__elasticsearch__.create_index!
      model.__elasticsearch__.import
    end
  end
end
