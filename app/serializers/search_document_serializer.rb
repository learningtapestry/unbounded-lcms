class SearchDocumentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :model_id, :model_type, :title, :path, :type_name, :teaser,
             :breadcrumbs, :subject, :grade

  def path
    if model_type == 'content_guide'
      content_guide_path(object.permalink || object.model_id, slug: object.slug)
    else
      return media_path(object.model_id) if media?
      return generic_path(object.model_id) if generic?

      object.slug ? show_with_slug_path(object.slug) : resource_permalink
    end
  end

  def type_name
    if generic? && object.grade.present?
      "#{object.grades.to_str} #{object.doc_type.titleize}"
    else
      object.doc_type.titleize
    end
  end

  def grade
    object.grades.average
  end

  private

  def media?
    %w(video podcast).include?(object.doc_type)
  end

  def generic?
    %w(text_set quick_reference_guide).include?(object.doc_type)
  end

  def content_guide?
    object.doc_type == 'content_guide'
  end

  def document_permalink
    document = Resource.find(object.model_id).document
    document_path(document.id)
  end

  def resource_permalink
    resource_path(object.model_id)
  end
end
