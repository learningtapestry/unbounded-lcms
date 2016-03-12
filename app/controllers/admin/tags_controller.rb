class Admin::TagsController < Admin::AdminController
  def create
    tag_params = params.require('tag').permit(:name)
    @tag = Tag.find_or_create_by!(name: tag_params[:name])
    @association = params[:association]
  end
end
