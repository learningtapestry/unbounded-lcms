namespace :standards do

  desc 'Import all CCSS standards from Common Standards Project'
  task import: [:environment] do
    Standard.import
    puts "Imported all CCSS standards from Common Standards Project."
  end
end
