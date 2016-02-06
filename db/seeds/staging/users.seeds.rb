User.create_with(
  name: 'Admin',
  password: 'adminlt123'
).find_or_create_by!(
  email: 'content-admin@learningtapestry.com'
)
