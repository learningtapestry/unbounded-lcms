include Content::Models

after :organizations, :roles do
  email    = 'content-admin@learningtapestry.com'
  name     = 'Admin'
  password = 'adminlt123'

  admin = Content::Models::User.create_with(name: name, password: password).find_or_create_by!(email: email)

  admin.add_to_organization(Organization.lt)
  admin.add_to_organization(Organization.unbounded)

  admin.add_role(Organization.lt, Role.named(:admin))
  admin.add_role(Organization.unbounded, Role.named(:admin))
end
