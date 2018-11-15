# frozen_string_literal: true

SVGSocialThumbnail.class_eval do
  def content_type
    if resource.is_a?(ContentGuide)
      'CONTENT GUIDE'
    elsif resource.generic? || resource.media?
      I18n.t("resource_types.#{resource.resource_type}").upcase
    elsif resurce.unit? && resource.short_title.match(/topic/i)
      'TOPIC'
    elsif resource.lesson?
      'LESSON PLAN'
    else
      resource.curriculum_type.try(:upcase)
    end
  end
end
