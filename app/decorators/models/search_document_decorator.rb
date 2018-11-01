# frozen_string_literal: true

Search::Document.class_eval do
  def self.build_from(model)
    if model.is_a?(Resource)
      new(**attrs_from_resource(model))

    elsif model.is_a?(ContentGuide)
      new(**attrs_from_content_guide(model))

    elsif model.is_a?(ExternalPage)
      new(**attrs_from_page(model))

    else
      raise "Unsupported Type for Search : #{model.class.name}"
    end
  end

  private

  def self.attrs_from_content_guide(model)
    {
      breadcrumbs: nil,
      description: model.description,
      doc_type: 'content_guide',
      document_metadata: nil,
      grade: model.grades.list,
      id: "content_guide_#{model.id}",
      model_type: :content_guide,
      model_id: model.id,
      permalink: model.permalink,
      position: grade_position(model),
      slug: model.slug,
      subject: model.subject,
      tag_authors: [],
      tag_keywords: [],
      tag_standards: [],
      tag_texts: [],
      teaser: model.teaser,
      title: model.title
    }
  end
end
