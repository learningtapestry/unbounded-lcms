# frozen_string_literal: true

Material.class_eval do
  serialize :metadata, DocTemplate::Objects::MaterialMetadata

  def pdf?
    metadata.type.casecmp('pdf').zero?
  end
end
