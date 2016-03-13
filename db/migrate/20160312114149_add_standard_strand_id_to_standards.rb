class AddStandardStrandIdToStandards < ActiveRecord::Migration
  def change
    add_reference :standards, :standard_strand, index: true, foreign_key: true
  end
end
