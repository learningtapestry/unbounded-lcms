# frozen_string_literal: true

class AddBreadcrumbShortPieceToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :breadcrumb_short_piece, :string
  end
end
