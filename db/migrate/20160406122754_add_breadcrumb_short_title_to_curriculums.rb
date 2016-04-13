class AddBreadcrumbShortTitleToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :breadcrumb_short_title, :string
  end
end
