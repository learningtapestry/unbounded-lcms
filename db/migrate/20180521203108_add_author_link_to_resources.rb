# frozen_string_literal: true

class AddAuthorLinkToResources < ActiveRecord::Migration
  def change
    add_reference :resources, :author, index: true
  end
end
