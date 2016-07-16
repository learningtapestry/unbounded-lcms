class ResourceTasks
  class << self
    def fix_formatting
      Resource.transaction do
        Resource.find_each do |res|
          desc = res.description.try(:strip)

          should_fix_newlines = \
            desc.present? &&
            (desc =~ /<\//).nil? &&
            (desc =~ /\r?\n/)

          if should_fix_newlines
            res.description = desc.gsub(/\r?\n/, '<br>')
            puts "Transformed newlines for resource #{res.id} - #{res.title}"
          end

          res.save!
        end
      end
    end
  end
end
