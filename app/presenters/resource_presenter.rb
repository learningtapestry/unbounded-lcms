class ResourcePresenter < SimpleDelegator
  def tags
    subjects.order(name: :asc).pluck(:name).join(', ')
  end

  def teaser_text
    description ? h.truncate_html(description, length: 150).html_safe : ''
  end

  protected
    def h
      ApplicationController.helpers
    end
end
