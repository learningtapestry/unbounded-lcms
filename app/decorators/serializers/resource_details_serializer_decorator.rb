# frozen_string_literal: true

ResourceDetailsSerializer.class_eval do
  def has_related # rubocop:disable Naming/PredicateName
    # based on 'find_related_instructions' method from 'ResourcesController'
    object.standards.any? do |standard|
      standard.content_guides.exists? || standard.resources.media.exists?
    end
  end
end
