class CreateCurriculumTypes < ActiveRecord::Migration
  def change
    create_table :curriculum_types do |t|
      t.string :name, null: false
    end
  end
end
