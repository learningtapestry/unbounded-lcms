include Content::Models

DownloadCategory.find_or_create_by!(name: 'rubrics_and_tools')
DownloadCategory.find_or_create_by!(name: 'texts')
