# frozen_string_literal: true

class DropContentGuideStandards < ActiveRecord::Migration
  def change
    drop_table :content_guide_standards do
    end
  end
end
