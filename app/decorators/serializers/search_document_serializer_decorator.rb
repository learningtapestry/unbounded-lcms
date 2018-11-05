# frozen_string_literal: true

SearchDocumentSerializer.class_eval do
  alias_method :original_path, :path

  def path
    if model_type == 'content_guide'
      return content_guide_path(object.permalink || object.model_id, slug: object.slug)
    end

    original_path
  end

  def content_guide?
    object.doc_type == 'content_guide'
  end
end
