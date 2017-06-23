class SearchDocumentPresenter < SimpleDelegator
  def data_object
    @data_object ||=
      if document?
        DocumentPresenter.new(document)
      else
        __getobj__
      end
  end

  def model_type
    document? ? :document : :resource
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
