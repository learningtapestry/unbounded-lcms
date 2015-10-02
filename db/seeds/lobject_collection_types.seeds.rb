include Content::Models

LobjectCollectionType.find_or_create_by!(name: LobjectCollectionType::ELA_CURRICULUM_MAP_NAME)
LobjectCollectionType.find_or_create_by!(name: LobjectCollectionType::MATH_CURRICULUM_MAP_NAME)
LobjectCollectionType.find_or_create_by!(name: 'NTI')
