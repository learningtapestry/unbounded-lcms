class AddStandardDomainIdToStandards < ActiveRecord::Migration
  def change
    add_reference :standards, :standard_domain, index: true, foreign_key: true
  end
end
