after :organizations, :roles do
  email    = 'content-admin@learningtapestry.com'
  name     = 'Admin'
  password = 'adminlt123'

  admin = User.create_with(name: name, password: password).find_or_create_by!(email: email)
end
