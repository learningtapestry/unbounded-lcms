namespace :oneoff do
  desc 'Fix duplicated stds (issue 461)'
  task issue_461: :environment do
    ['hsn.q.a.1', 'hsn.q.a.2', 'hsn.q.a.3'].each do |std|
      wrong_std = Standard.find_by(name: std)
      right_std = Standard.where("alt_names @> '{#{std}}' AND name != '#{std}'").first

      right_std.emphasis = wrong_std.emphasis
      right_std.cluster_id = wrong_std.cluster_id
      right_std.save
      wrong_std.destroy

      puts "Standard fixed : #{right_std.name}"
    end
  end

  desc "Fix missing tags on text sets (issue 497)"
  task text_set_tags: :environment do
    puts "==== Adding tags to Text Sets"
    Resource.text_set.each do |resource|
      resource.tag_list << 'Expert Packs'
      resource.tag_list << 'Text Set'
      saved =  resource.save
      print(saved ?  '.' : 'F')
    end
    puts "\n"
  end

  desc "Fix Core Proficiencies data cleanup (issue 502)"
  task issue_502: :environment do
    Oneoff.fix '502'
  end
end

