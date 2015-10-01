include Content::Models

Role.find_or_create_by!(name: 'admin')
