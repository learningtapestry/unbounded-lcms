# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'content/models'; include Content::Models

unbounded_org = Organization.find_or_create_by!(name: 'UnboundEd')
lt_org = Organization.find_or_create_by!(name: 'LearningTapestry')
admin_role = Role.find_or_create_by!(name: 'admin')

unless Rails.env.production?
  admin = User.create_with(name: 'Admin', password: 'adminlt123').find_or_create_by!(email: 'content-admin@learningtapestry.com')
  admin.add_to_organization(unbounded_org)
  admin.add_role(unbounded_org, admin_role)
  admin.add_role(lt_org, admin_role)
end

# Collection Types
LobjectCollectionType.find_or_create_by!(name: 'Curriculum Map')
LobjectCollectionType.find_or_create_by!(name: 'NTI')
