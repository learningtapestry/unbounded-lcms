namespace :oneoff do
  desc "Fix Core Proficiencies data cleanup (issue 502)"
  task issue_502: :environment do
    Oneoff.fix '502'
  end

  desc "Fix ELA PK-2 data cleanup (issue 503)"
  task issue_503: :environment do
    Oneoff.fix '503'
  end
end

