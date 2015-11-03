# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151103065416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alignments", force: :cascade do |t|
    t.string   "name"
    t.string   "framework"
    t.string   "framework_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "alignments", ["framework"], name: "index_alignments_on_framework", using: :btree
  add_index "alignments", ["framework_url"], name: "index_alignments_on_framework_url", using: :btree
  add_index "alignments", ["parent_id"], name: "index_alignments_on_parent_id", using: :btree

  create_table "document_age_ranges", force: :cascade do |t|
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_age"
    t.integer  "max_age"
    t.boolean  "extended_age"
  end

  add_index "document_age_ranges", ["document_id"], name: "index_document_age_ranges_on_document_id", using: :btree

  create_table "document_alignments", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "alignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_alignments", ["alignment_id"], name: "index_document_alignments_on_alignment_id", using: :btree
  add_index "document_alignments", ["document_id"], name: "index_document_alignments_on_document_id", using: :btree

  create_table "document_downloads", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "download_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "active"
  end

  add_index "document_downloads", ["document_id"], name: "index_document_downloads_on_document_id", using: :btree
  add_index "document_downloads", ["download_id"], name: "index_document_downloads_on_download_id", using: :btree

  create_table "document_grades", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "grade_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_grades", ["document_id"], name: "index_document_grades_on_document_id", using: :btree
  add_index "document_grades", ["grade_id"], name: "index_document_grades_on_grade_id", using: :btree

  create_table "document_identities", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "identity_id"
    t.integer  "identity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_identities", ["document_id"], name: "index_document_identities_on_document_id", using: :btree
  add_index "document_identities", ["identity_id"], name: "index_document_identities_on_identity_id", using: :btree
  add_index "document_identities", ["identity_type"], name: "index_document_identities_on_identity_type", using: :btree

  create_table "document_languages", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_languages", ["document_id"], name: "index_document_languages_on_document_id", using: :btree
  add_index "document_languages", ["language_id"], name: "index_document_languages_on_language_id", using: :btree

  create_table "document_resource_types", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "resource_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "document_resource_types", ["document_id"], name: "index_document_resource_types_on_document_id", using: :btree
  add_index "document_resource_types", ["resource_type_id"], name: "index_document_resource_types_on_resource_type_id", using: :btree

  create_table "document_subjects", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_subjects", ["document_id"], name: "index_document_subjects_on_document_id", using: :btree
  add_index "document_subjects", ["subject_id"], name: "index_document_subjects_on_subject_id", using: :btree

  create_table "document_topics", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "topic_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "description"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "merged_at"
    t.integer  "url_id"
    t.datetime "doc_created_at"
    t.integer  "source_document_id"
    t.boolean  "active"
  end

  add_index "documents", ["merged_at"], name: "index_documents_on_merged_at", using: :btree
  add_index "documents", ["url_id"], name: "index_documents_on_url_id", using: :btree

  create_table "downloads", force: :cascade do |t|
    t.string   "filename"
    t.integer  "filesize"
    t.string   "url"
    t.string   "content_type"
    t.string   "title"
    t.string   "description"
    t.integer  "parent_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "downloads", ["parent_id"], name: "index_downloads_on_parent_id", using: :btree

  create_table "engageny_documents", force: :cascade do |t|
    t.integer  "nid"
    t.text     "title"
    t.text     "description"
    t.datetime "doc_created_at"
    t.jsonb    "grades"
    t.jsonb    "subjects"
    t.jsonb    "topics"
    t.jsonb    "resource_types"
    t.jsonb    "standards"
    t.jsonb    "downloadable_resources"
    t.text     "url"
    t.boolean  "active"
    t.integer  "source_document_id"
  end

  add_index "engageny_documents", ["downloadable_resources"], name: "index_engageny_documents_on_downloadable_resources", using: :gin
  add_index "engageny_documents", ["grades"], name: "index_engageny_documents_on_grades", using: :gin
  add_index "engageny_documents", ["nid"], name: "index_engageny_documents_on_nid", using: :btree
  add_index "engageny_documents", ["resource_types"], name: "index_engageny_documents_on_resource_types", using: :gin
  add_index "engageny_documents", ["source_document_id"], name: "index_engageny_documents_on_source_document_id", using: :btree
  add_index "engageny_documents", ["standards"], name: "index_engageny_documents_on_standards", using: :gin
  add_index "engageny_documents", ["subjects"], name: "index_engageny_documents_on_subjects", using: :gin
  add_index "engageny_documents", ["topics"], name: "index_engageny_documents_on_topics", using: :gin

  create_table "grades", force: :cascade do |t|
    t.string   "grade"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "grades", ["parent_id"], name: "index_grades_on_parent_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "url"
    t.string   "description"
    t.string   "public_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "parent_id"
  end

  add_index "identities", ["parent_id"], name: "index_identities_on_parent_id", using: :btree
  add_index "identities", ["url"], name: "index_identities_on_url", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "languages", ["name"], name: "index_languages_on_name", using: :btree
  add_index "languages", ["parent_id"], name: "index_languages_on_parent_id", using: :btree

  create_table "lobject_additional_lobjects", force: :cascade do |t|
    t.integer  "lobject_id",            null: false
    t.integer  "additional_lobject_id", null: false
    t.integer  "position"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "lobject_additional_lobjects", ["additional_lobject_id"], name: "index_lobject_additional_lobjects_on_additional_lobject_id", using: :btree
  add_index "lobject_additional_lobjects", ["lobject_id", "additional_lobject_id"], name: "index_lobject_additional_lobjects", unique: true, using: :btree

  create_table "lobject_age_ranges", force: :cascade do |t|
    t.integer  "lobject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_age"
    t.integer  "max_age"
    t.boolean  "extended_age"
    t.integer  "document_id"
  end

  add_index "lobject_age_ranges", ["document_id"], name: "index_lobject_age_ranges_on_document_id", using: :btree
  add_index "lobject_age_ranges", ["lobject_id"], name: "index_lobject_age_ranges_on_lobject_id", using: :btree

  create_table "lobject_alignments", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "alignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
  end

  add_index "lobject_alignments", ["alignment_id"], name: "index_lobject_alignments_on_alignment_id", using: :btree
  add_index "lobject_alignments", ["document_id"], name: "index_lobject_alignments_on_document_id", using: :btree
  add_index "lobject_alignments", ["lobject_id"], name: "index_lobject_alignments_on_lobject_id", using: :btree

  create_table "lobject_children", force: :cascade do |t|
    t.integer  "parent_id",             null: false
    t.integer  "child_id",              null: false
    t.integer  "position",              null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "lobject_collection_id", null: false
  end

  add_index "lobject_children", ["child_id"], name: "index_lobject_children_on_child_id", using: :btree
  add_index "lobject_children", ["lobject_collection_id", "child_id"], name: "index_lobject_children_on_lobject_collection_id_and_child_id", unique: true, using: :btree
  add_index "lobject_children", ["parent_id"], name: "index_lobject_children_on_parent_id", using: :btree

  create_table "lobject_collection_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lobject_collection_types", ["name"], name: "index_lobject_collection_types_on_name", unique: true, using: :btree

  create_table "lobject_collections", force: :cascade do |t|
    t.integer  "lobject_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "lobject_collection_type_id"
  end

  add_index "lobject_collections", ["lobject_collection_type_id"], name: "index_lobject_collections_on_lobject_collection_type_id", using: :btree
  add_index "lobject_collections", ["lobject_id"], name: "index_lobject_collections_on_lobject_id", using: :btree

  create_table "lobject_descriptions", force: :cascade do |t|
    t.string   "description"
    t.integer  "lobject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
    t.datetime "doc_created_at"
  end

  add_index "lobject_descriptions", ["document_id"], name: "index_lobject_descriptions_on_document_id", using: :btree
  add_index "lobject_descriptions", ["lobject_id"], name: "index_lobject_descriptions_on_lobject_id", using: :btree

  create_table "lobject_documents", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lobject_documents", ["document_id"], name: "index_lobject_documents_on_document_id", using: :btree
  add_index "lobject_documents", ["lobject_id"], name: "index_lobject_documents_on_lobject_id", using: :btree

  create_table "lobject_downloads", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "document_id"
    t.integer  "download_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "active"
  end

  add_index "lobject_downloads", ["document_id"], name: "index_lobject_downloads_on_document_id", using: :btree
  add_index "lobject_downloads", ["download_id"], name: "index_lobject_downloads_on_download_id", using: :btree
  add_index "lobject_downloads", ["lobject_id"], name: "index_lobject_downloads_on_lobject_id", using: :btree

  create_table "lobject_grades", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "document_id"
    t.integer  "grade_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "lobject_grades", ["document_id"], name: "index_lobject_grades_on_document_id", using: :btree
  add_index "lobject_grades", ["grade_id"], name: "index_lobject_grades_on_grade_id", using: :btree
  add_index "lobject_grades", ["lobject_id"], name: "index_lobject_grades_on_lobject_id", using: :btree

  create_table "lobject_identities", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "identity_id"
    t.integer  "identity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
  end

  add_index "lobject_identities", ["document_id"], name: "index_lobject_identities_on_document_id", using: :btree
  add_index "lobject_identities", ["identity_id"], name: "index_lobject_identities_on_identity_id", using: :btree
  add_index "lobject_identities", ["identity_type"], name: "index_lobject_identities_on_identity_type", using: :btree
  add_index "lobject_identities", ["lobject_id"], name: "index_lobject_identities_on_lobject_id", using: :btree

  create_table "lobject_languages", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "document_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "lobject_languages", ["document_id"], name: "index_lobject_languages_on_document_id", using: :btree
  add_index "lobject_languages", ["language_id"], name: "index_lobject_languages_on_language_id", using: :btree
  add_index "lobject_languages", ["lobject_id"], name: "index_lobject_languages_on_lobject_id", using: :btree

  create_table "lobject_related_lobjects", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "related_lobject_id"
    t.integer  "position"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "lobject_related_lobjects", ["lobject_id"], name: "index_lobject_related_lobjects_on_lobject_id", using: :btree
  add_index "lobject_related_lobjects", ["related_lobject_id"], name: "index_lobject_related_lobjects_on_related_lobject_id", using: :btree

  create_table "lobject_resource_types", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "document_id"
    t.integer  "resource_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "lobject_resource_types", ["document_id"], name: "index_lobject_resource_types_on_document_id", using: :btree
  add_index "lobject_resource_types", ["lobject_id"], name: "index_lobject_resource_types_on_lobject_id", using: :btree
  add_index "lobject_resource_types", ["resource_type_id"], name: "index_lobject_resource_types_on_resource_type_id", using: :btree

  create_table "lobject_slugs", force: :cascade do |t|
    t.integer  "lobject_id",            null: false
    t.integer  "lobject_collection_id"
    t.string   "value",                 null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "lobject_slugs", ["lobject_collection_id"], name: "index_lobject_slugs_on_lobject_collection_id", using: :btree
  add_index "lobject_slugs", ["lobject_id", "lobject_collection_id"], name: "index_lobject_slugs_on_lobject_id_and_lobject_collection_id", unique: true, using: :btree
  add_index "lobject_slugs", ["value"], name: "index_lobject_slugs_on_value", unique: true, using: :btree

  create_table "lobject_subjects", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
  end

  add_index "lobject_subjects", ["document_id"], name: "index_lobject_subjects_on_document_id", using: :btree
  add_index "lobject_subjects", ["lobject_id"], name: "index_lobject_subjects_on_lobject_id", using: :btree
  add_index "lobject_subjects", ["subject_id"], name: "index_lobject_subjects_on_subject_id", using: :btree

  create_table "lobject_titles", force: :cascade do |t|
    t.string   "title"
    t.integer  "lobject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
    t.datetime "doc_created_at"
    t.string   "subtitle"
  end

  add_index "lobject_titles", ["document_id"], name: "index_lobject_titles_on_document_id", using: :btree
  add_index "lobject_titles", ["lobject_id"], name: "index_lobject_titles_on_lobject_id", using: :btree

  create_table "lobject_topics", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "document_id"
    t.integer  "topic_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "lobject_urls", force: :cascade do |t|
    t.integer  "lobject_id"
    t.integer  "url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_id"
  end

  add_index "lobject_urls", ["document_id"], name: "index_lobject_urls_on_document_id", using: :btree
  add_index "lobject_urls", ["lobject_id"], name: "index_lobject_urls_on_lobject_id", using: :btree
  add_index "lobject_urls", ["url_id"], name: "index_lobject_urls_on_url_id", using: :btree

  create_table "lobjects", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "indexed_at"
    t.boolean  "hidden",          default: false
    t.integer  "organization_id"
  end

  add_index "lobjects", ["indexed_at"], name: "index_lobjects_on_indexed_at", using: :btree
  add_index "lobjects", ["organization_id"], name: "index_lobjects_on_organization_id", using: :btree

  create_table "lr_document_logs", force: :cascade do |t|
    t.string   "action"
    t.date     "newest_import_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lr_documents", force: :cascade do |t|
    t.string   "doc_id"
    t.boolean  "active"
    t.string   "doc_type"
    t.string   "doc_version"
    t.string   "payload_placement"
    t.string   "resource_data_type"
    t.string   "resource_locator"
    t.text     "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "resource_data_json"
    t.xml      "resource_data_xml"
    t.text     "resource_data_string"
    t.jsonb    "identity"
    t.jsonb    "keys"
    t.jsonb    "payload_schema"
    t.datetime "format_parsed_at"
    t.integer  "source_document_id"
  end

  add_index "lr_documents", ["doc_id"], name: "index_lr_documents_on_doc_id", unique: true, using: :btree
  add_index "lr_documents", ["format_parsed_at"], name: "index_lr_documents_on_format_parsed_at", using: :btree
  add_index "lr_documents", ["identity"], name: "raw_doc_ide_gin", using: :gin
  add_index "lr_documents", ["keys"], name: "raw_doc_key_gin", using: :gin
  add_index "lr_documents", ["payload_schema"], name: "raw_doc_pay_sch_gin", using: :gin
  add_index "lr_documents", ["source_document_id"], name: "index_lr_documents_on_source_document_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string "name"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "pages", force: :cascade do |t|
    t.text     "body",       null: false
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  create_table "resource_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "resource_types", ["name"], name: "index_resource_types_on_name", using: :btree
  add_index "resource_types", ["parent_id"], name: "index_resource_types_on_parent_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name",        null: false
    t.string "description"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "source_documents", force: :cascade do |t|
    t.datetime "conformed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "source_type"
  end

  add_index "source_documents", ["conformed_at"], name: "index_source_documents_on_conformed_at", using: :btree
  add_index "source_documents", ["source_type"], name: "index_source_documents_on_source_type", using: :btree

  create_table "staff_members", force: :cascade do |t|
    t.string   "bio",        limit: 4096
    t.string   "name",                    null: false
    t.string   "position"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "subjects", ["name"], name: "index_subjects_on_name", using: :btree
  add_index "subjects", ["parent_id"], name: "index_subjects_on_parent_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["name"], name: "index_topics_on_name", using: :btree
  add_index "topics", ["parent_id"], name: "index_topics_on_parent_id", using: :btree

  create_table "urls", force: :cascade do |t|
    t.text     "url",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "http_status"
    t.datetime "checked_at"
  end

  add_index "urls", ["checked_at"], name: "index_urls_on_checked_at", using: :btree
  add_index "urls", ["parent_id"], name: "index_urls_on_parent_id", using: :btree
  add_index "urls", ["url"], name: "index_urls_on_url", using: :btree

  create_table "user_organizations", force: :cascade do |t|
    t.integer "user_id",         null: false
    t.integer "organization_id", null: false
  end

  add_index "user_organizations", ["organization_id"], name: "index_user_organizations_on_organization_id", using: :btree
  add_index "user_organizations", ["user_id", "organization_id"], name: "index_user_organizations_on_user_id_and_organization_id", unique: true, using: :btree
  add_index "user_organizations", ["user_id"], name: "index_user_organizations_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "organization_id"
  end

  add_index "user_roles", ["organization_id"], name: "index_user_roles_on_organization_id", using: :btree
  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id", "organization_id", "role_id"], name: "index_user_roles_on_user_id_and_organization_id_and_role_id", unique: true, using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "alignments", "alignments", column: "parent_id"
  add_foreign_key "document_age_ranges", "documents"
  add_foreign_key "document_alignments", "alignments"
  add_foreign_key "document_alignments", "documents"
  add_foreign_key "document_downloads", "documents"
  add_foreign_key "document_downloads", "downloads"
  add_foreign_key "document_grades", "documents"
  add_foreign_key "document_grades", "grades"
  add_foreign_key "document_identities", "documents"
  add_foreign_key "document_identities", "identities"
  add_foreign_key "document_languages", "documents"
  add_foreign_key "document_languages", "languages"
  add_foreign_key "document_resource_types", "documents"
  add_foreign_key "document_resource_types", "resource_types"
  add_foreign_key "document_subjects", "documents"
  add_foreign_key "document_subjects", "subjects"
  add_foreign_key "documents", "source_documents"
  add_foreign_key "documents", "urls"
  add_foreign_key "downloads", "downloads", column: "parent_id"
  add_foreign_key "engageny_documents", "source_documents"
  add_foreign_key "grades", "grades", column: "parent_id"
  add_foreign_key "identities", "identities", column: "parent_id"
  add_foreign_key "languages", "languages", column: "parent_id"
  add_foreign_key "lobject_additional_lobjects", "lobjects"
  add_foreign_key "lobject_additional_lobjects", "lobjects", column: "additional_lobject_id"
  add_foreign_key "lobject_age_ranges", "documents"
  add_foreign_key "lobject_age_ranges", "lobjects"
  add_foreign_key "lobject_alignments", "alignments"
  add_foreign_key "lobject_alignments", "documents"
  add_foreign_key "lobject_alignments", "lobjects"
  add_foreign_key "lobject_children", "lobject_collections"
  add_foreign_key "lobject_children", "lobjects", column: "child_id"
  add_foreign_key "lobject_children", "lobjects", column: "parent_id"
  add_foreign_key "lobject_collections", "lobject_collection_types"
  add_foreign_key "lobject_collections", "lobjects"
  add_foreign_key "lobject_descriptions", "documents"
  add_foreign_key "lobject_descriptions", "lobjects"
  add_foreign_key "lobject_documents", "documents"
  add_foreign_key "lobject_documents", "lobjects"
  add_foreign_key "lobject_downloads", "documents"
  add_foreign_key "lobject_downloads", "downloads"
  add_foreign_key "lobject_downloads", "lobjects"
  add_foreign_key "lobject_grades", "documents"
  add_foreign_key "lobject_grades", "grades"
  add_foreign_key "lobject_grades", "lobjects"
  add_foreign_key "lobject_identities", "documents"
  add_foreign_key "lobject_identities", "identities"
  add_foreign_key "lobject_identities", "lobjects"
  add_foreign_key "lobject_languages", "documents"
  add_foreign_key "lobject_languages", "languages"
  add_foreign_key "lobject_languages", "lobjects"
  add_foreign_key "lobject_related_lobjects", "lobjects"
  add_foreign_key "lobject_related_lobjects", "lobjects", column: "related_lobject_id"
  add_foreign_key "lobject_resource_types", "documents"
  add_foreign_key "lobject_resource_types", "lobjects"
  add_foreign_key "lobject_resource_types", "resource_types"
  add_foreign_key "lobject_slugs", "lobject_collections"
  add_foreign_key "lobject_slugs", "lobjects"
  add_foreign_key "lobject_subjects", "documents"
  add_foreign_key "lobject_subjects", "lobjects"
  add_foreign_key "lobject_subjects", "subjects"
  add_foreign_key "lobject_titles", "documents"
  add_foreign_key "lobject_titles", "lobjects"
  add_foreign_key "lobject_urls", "documents"
  add_foreign_key "lobject_urls", "lobjects"
  add_foreign_key "lobject_urls", "urls"
  add_foreign_key "lobjects", "organizations"
  add_foreign_key "lr_documents", "source_documents"
  add_foreign_key "resource_types", "resource_types", column: "parent_id"
  add_foreign_key "subjects", "subjects", column: "parent_id"
  add_foreign_key "urls", "urls", column: "parent_id"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
  add_foreign_key "user_roles", "organizations"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
