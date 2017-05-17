class SearchDocumentPresenter < SimpleDelegator
  def data_object
    @data_object ||=
      if lesson_document?
        LessonDocumentPresenter.new(lesson_document)
      else
        __getobj__
      end
  end

  def model_type
    lesson_document? ? :lesson_document : :resource
  end

  def description
    data_object.description
  end

  def title
    data_object.title
  end

  def teaser
    data_object.teaser
  end
end
