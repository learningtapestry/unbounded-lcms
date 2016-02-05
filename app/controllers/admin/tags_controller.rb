class Admin::TagsController < Admin::AdminController
  def create
    tag_params = params.require('tag').permit(:name)
    @association = params[:association]
    @tag = Resource.new.send(@association).new(tag_params)
    @tag.save
  end
end
