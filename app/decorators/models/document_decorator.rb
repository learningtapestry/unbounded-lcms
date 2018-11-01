# frozen_string_literal: true

Document.class_eval do
  def prereq?
    metadata['type'].to_s.casecmp('prereq').zero?
  end

  def fix_prereq_position(resource)
    next_lesson = resource.siblings.detect do |r|
      break r unless r.prerequisite? # first non-prereq

      # grab the first prereq lesson with a bigger lesson num
      r.lesson_number > metadata['lesson'].to_i
    end
    next_lesson&.prepend_sibling(resource)
  end

  def set_resource_from_metadata
    return unless metadata.present?

    resource = MetadataContext.new(metadata).find_or_create_resource

    # if resource changed to prerequisite, fix positioning
    fix_prereq_position(resource) if !resource.prerequisite? && prereq?

    # Update resource with document metadata
    resource.title = metadata['title'] if metadata['title'].present?
    resource.teaser = metadata['teaser'] if metadata['teaser'].present?
    resource.description = metadata['description'] if metadata['description'].present?
    resource.tag_list << 'prereq' if prereq?
    resource.tag_list << 'opr' if metadata['type'].to_s.casecmp('opr').zero?
    resource.save

    self.resource_id = resource.id
  end
end
