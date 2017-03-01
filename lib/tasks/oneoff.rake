namespace :oneoff do
  desc "Add folder hierarchy structure to GDrive"
  task issue_6: :environment do
    Oneoff.fix '6'
  end
end

