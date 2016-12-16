namespace :oneoff do
  desc 'Fix duplicated stds (issue 461)'
  task issue_461: :environment do
    ['hsn.q.a.1', 'hsn.q.a.2', 'hsn.q.a.3'].each do |std|
      wrong_std = Standard.find_by(name: std)
      right_std = Standard.where("alt_names @> '{#{std}}' AND name != '#{std}'").first

      right_std.emphasis = wrong_std.emphasis
      # right.cluster_id = wrong.cluster_id
      right_std.save
      wrong_std.destroy

      puts "Standard fixed : #{right_std.name}"
    end
  end
end

