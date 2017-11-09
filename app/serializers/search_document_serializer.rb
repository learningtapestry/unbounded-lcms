class SearchDocumentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :model_id, :model_type, :title, :path, :type_name, :teaser, :breadcrumbs, :subject, :grade

  def path
    if model_type == 'content_guide'
      content_guide_path(object.permalink || object.model_id, slug: object.slug)
    elsif model_type == 'page'
      object.permalink
    else
      return media_path(object.model_id) if media?
      return generic_path(object.model_id) if generic?
      if (slug = object.slug)
        show_with_slug_path(slug)
      else
        resource_path(object.model_id)
      end
    end
  end

  def type_name
    return object.doc_type.titleize unless generic? && object.grade.present?
    presenter = GenericPresenter.new(object)
    "#{presenter.grades_to_str} #{object.doc_type.titleize}"
  end

  def grade
    generic? || media? || content_guide? ? object.grade_avg : object.grade_color_code
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
end
