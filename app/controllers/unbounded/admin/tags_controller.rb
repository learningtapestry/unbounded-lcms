module Unbounded
  module Admin
    class TagsController < AdminController
      def create
        tag_params = params.require('tag').permit(:name)
        @association = params[:association]
        @tag = Lobject.new.send(@association).new(tag_params)
        @tag.save
      end
    end
  end
end
