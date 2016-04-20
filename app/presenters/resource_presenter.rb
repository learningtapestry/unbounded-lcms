class ResourcePresenter < SimpleDelegator
  def tags
    super.sort.join(', ')
  end

  protected
    def h
      ApplicationController.helpers
    end
end
