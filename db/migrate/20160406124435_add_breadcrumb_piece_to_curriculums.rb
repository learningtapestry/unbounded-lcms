class AddBreadcrumbPieceToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :breadcrumb_piece, :string
  end
end
