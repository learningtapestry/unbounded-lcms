# frozen_string_literal: true

class ResourceTasks
  def self.fix_formatting
    ActiveRecord::Base.transaction do
      Resource.find_each do |res|
        desc = res.description.try(:strip)

        should_fix_newlines = desc.present? && (desc =~ %r{</}).nil? && (desc =~ /\r?\n/)

        if should_fix_newlines
          res.description = desc.gsub(/\r?\n/, '<br>')
          puts "Transformed newlines for resource #{res.id} - #{res.title}"
        end

        res.save!
      end
    end
  end

  def self.fix_lessons_metadata
    Resource.lessons.each do |res|
      next unless res.document?

      md = res.document.metadata
      attrs = {
        title:  md['title'].presence,
        teaser:  md['teaser'].presence,
        description:  md['description'].presence
      }.compact
      res.update(**attrs) if attrs.present?
    end
  end

  def self.generate_unit_bundles
    Resource.tree.units.each do |unit|
      DocumentBundle::CATEGORIES.each do |category|
        DocumentBundle.update_bundle(unit, category)
        print '.'
      end
    end
    puts "\n"
  end

  def self.sync_reading_assignments
    ActiveRecord::Base.transaction do
      %i(units modules grades).each do |level|
        Resource.tree.send(level).find_each do |res|
          res.reading_assignments.destroy_all
          text_ids = res.children.joins(:resource_reading_assignments).pluck(:reading_assignment_text_id).uniq
          text_ids.each { |id| ResourceReadingAssignment.create(resource_id: res.id, reading_assignment_text_id: id) }
        end
      end
    end
  end

  def self.update_time_to_teach
    ActiveRecord::Base.transaction do
      Resource.lessons.find_each do |res|
        next if res.time_to_teach.present? && res.time_to_teach != 0
        res.update_attributes(time_to_teach: 60)
      end

      %i(units modules grades subjects).each do |level|
        Resource.send(level).find_each do |res|
          total = res.children.map(&:time_to_teach).sum
          res.update_attributes(time_to_teach: total)
        end
      end
    end
  end
end
