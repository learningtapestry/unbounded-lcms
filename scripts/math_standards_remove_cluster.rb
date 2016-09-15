

# This script should be run from RoR console
# $ load 'scripts/math_standards_remove_cluster.rb'

r = '[^\.]+'
expr = /#{r}\.math\.#{r}\.(#{r})\.(#{r})\.#{r}\.(#{r})/
review = []
Standard.find_each do |s|
  next unless s.name =~ /\.math\./
  if m = s.name.match(expr)
    alt_name = "#{m[1]}.#{m[2]}.#{m[3]}"
    puts "-- #{s.name} adding alias: #{alt_name}"
    unless s.alt_names.include?(alt_name)
      s.alt_names << alt_name
      s.save
    end
  else
    review << s.name
  end
end

puts "-- # To be reviewed"
review.each do |standard|
  puts standard
end

