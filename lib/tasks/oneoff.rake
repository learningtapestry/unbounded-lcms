namespace :oneoff do
  desc "Fix Core Proficiencies data cleanup (issue 502)"
  task issue_502: :environment do
    Oneoff.fix '502'
  end
end

