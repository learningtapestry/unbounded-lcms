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

ActiveRecord::Schema.define(version: 20170827203654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "access_codes", force: :cascade do |t|
    t.string   "code",                      null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "access_codes", ["code"], name: "index_access_codes_on_code", unique: true, using: :btree

  create_table "content_guide_definitions", force: :cascade do |t|
    t.string   "keyword",     null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "content_guide_definitions", ["keyword"], name: "index_content_guide_definitions_on_keyword", unique: true, using: :btree

  create_table "content_guide_faqs", force: :cascade do |t|
    t.string   "title",                       null: false
    t.string   "description",                 null: false
    t.string   "subject",                     null: false
    t.string   "heading",                     null: false
    t.string   "subheading",                  null: false
    t.boolean  "active",      default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "content_guide_faqs", ["active"], name: "index_content_guide_faqs_on_active", using: :btree
  add_index "content_guide_faqs", ["subject"], name: "index_content_guide_faqs_on_subject", using: :btree

  create_table "content_guide_images", force: :cascade do |t|
    t.string   "file",         null: false
    t.string   "original_url", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "content_guide_images", ["original_url"], name: "index_content_guide_images_on_original_url", unique: true, using: :btree

  create_table "content_guide_standards", force: :cascade do |t|
    t.integer  "content_guide_id", null: false
    t.integer  "standard_id",      null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "content_guide_standards", ["content_guide_id", "standard_id"], name: "index_content_guide_standards", unique: true, using: :btree
  add_index "content_guide_standards", ["standard_id"], name: "index_content_guide_standards_on_standard_id", using: :btree

  create_table "content_guides", force: :cascade do |t|
    t.string   "content",                   null: false
    t.string   "file_id",                   null: false
    t.string   "name",                      null: false
    t.string   "original_content",          null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "last_modified_at"
    t.string   "last_modifying_user_email"
    t.string   "last_modifying_user_name"
    t.integer  "version"
    t.string   "big_photo"
    t.date     "date"
    t.string   "description"
    t.string   "small_photo"
    t.string   "subject"
    t.string   "teaser"
    t.string   "title"
    t.string   "permalink"
    t.string   "slug"
    t.string   "pdf"
  end

  add_index "content_guides", ["file_id"], name: "index_content_guides_on_file_id", unique: true, using: :btree
  add_index "content_guides", ["permalink"], name: "index_content_guides_on_permalink", unique: true, using: :btree

  create_table "copyright_attributions", force: :cascade do |t|
    t.string   "disclaimer"
    t.string   "value",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "resource_id", null: false
  end

  create_table "curriculum_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "curriculum_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "curriculum_anc_desc_idx", unique: true, using: :btree
  add_index "curriculum_hierarchies", ["descendant_id"], name: "curriculum_desc_idx", using: :btree

  create_table "curriculum_trees", force: :cascade do |t|
    t.string   "name",                       null: false
    t.jsonb    "tree",       default: {},    null: false
    t.boolean  "default",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "curriculum_types", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "curriculums", force: :cascade do |t|
    t.integer "curriculum_type_id",     null: false
    t.integer "parent_id"
    t.integer "position"
    t.integer "item_id",                null: false
    t.string  "item_type",              null: false
    t.integer "seed_id"
    t.string  "breadcrumb_title"
    t.string  "breadcrumb_short_title"
    t.string  "breadcrumb_piece"
    t.string  "breadcrumb_short_piece"
    t.string  "hierarchical_position"
  end

  add_index "curriculums", ["curriculum_type_id"], name: "index_curriculums_on_curriculum_type_id", using: :btree
  add_index "curriculums", ["item_id"], name: "index_curriculums_on_item_id", using: :btree
  add_index "curriculums", ["item_type"], name: "index_curriculums_on_item_type", using: :btree
  add_index "curriculums", ["parent_id"], name: "index_curriculums_on_parent_id", using: :btree

  create_table "document_parts", force: :cascade do |t|
    t.integer  "document_id"
    t.text     "content"
    t.string   "part_type"
    t.boolean  "active"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "placeholder"
    t.text     "materials",    default: [], null: false, array: true
    t.integer  "context_type", default: 0
    t.string   "anchor"
  end

  add_index "document_parts", ["anchor"], name: "index_document_parts_on_anchor", using: :btree
  add_index "document_parts", ["context_type"], name: "index_document_parts_on_context_type", using: :btree
  add_index "document_parts", ["document_id"], name: "index_document_parts_on_document_id", using: :btree
  add_index "document_parts", ["placeholder"], name: "index_document_parts_on_placeholder", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "file_id"
    t.string   "name"
    t.datetime "last_modified_at"
    t.string   "last_author_email"
    t.string   "last_author_name"
    t.text     "original_content"
    t.string   "version"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.hstore   "metadata"
    t.jsonb    "activity_metadata"
    t.integer  "resource_id"
    t.jsonb    "toc"
    t.boolean  "active",                default: true, null: false
    t.hstore   "foundational_metadata"
    t.text     "css_styles"
    t.jsonb    "links",                 default: {},   null: false
    t.jsonb    "agenda_metadata"
  end

  add_index "documents", ["file_id"], name: "index_documents_on_file_id", using: :btree
  add_index "documents", ["metadata"], name: "index_documents_on_metadata", using: :gist
  add_index "documents", ["resource_id"], name: "index_documents_on_resource_id", using: :btree

  create_table "documents_materials", id: false, force: :cascade do |t|
    t.integer "document_id"
    t.integer "material_id"
  end

  add_index "documents_materials", ["document_id", "material_id"], name: "index_documents_materials_on_document_id_and_material_id", unique: true, using: :btree
  add_index "documents_materials", ["material_id"], name: "index_documents_materials_on_material_id", using: :btree

  create_table "download_categories", force: :cascade do |t|
    t.string "name",        null: false
    t.string "description"
  end

  create_table "downloads", force: :cascade do |t|
    t.string   "filename"
    t.integer  "filesize"
    t.string   "url"
    t.string   "content_type"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "main",         default: false, null: false
  end

  create_table "leadership_posts", force: :cascade do |t|
    t.string   "first_name",               null: false
    t.string   "last_name",                null: false
    t.string   "school"
    t.string   "image_file"
    t.string   "description", limit: 4096
    t.integer  "order"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "leadership_posts", ["order", "last_name"], name: "index_leadership_posts_on_order_and_last_name", using: :btree

  create_table "material_parts", force: :cascade do |t|
    t.integer  "material_id"
    t.text     "content"
    t.integer  "context_type", default: 0
    t.string   "part_type"
    t.boolean  "active"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "material_parts", ["material_id"], name: "index_material_parts_on_material_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "file_id",                        null: false
    t.string   "identifier"
    t.jsonb    "metadata",          default: {}, null: false
    t.string   "name"
    t.datetime "last_modified_at"
    t.string   "last_author_email"
    t.string   "last_author_name"
    t.text     "original_content"
    t.string   "version"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "materials", ["file_id"], name: "index_materials_on_file_id", using: :btree
  add_index "materials", ["identifier"], name: "index_materials_on_identifier", using: :btree
  add_index "materials", ["metadata"], name: "index_materials_on_metadata", using: :gin

  create_table "pages", force: :cascade do |t|
    t.text     "body",       null: false
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  create_table "reading_assignment_authors", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reading_assignment_authors", ["name"], name: "index_reading_assignment_authors_on_name", unique: true, using: :btree

  create_table "reading_assignment_texts", force: :cascade do |t|
    t.string   "name",                         null: false
    t.integer  "reading_assignment_author_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reading_assignment_texts", ["name"], name: "index_reading_assignment_texts_on_name", using: :btree
  add_index "reading_assignment_texts", ["reading_assignment_author_id"], name: "index_reading_assignment_texts_on_reading_assignment_author_id", using: :btree

  create_table "resource_additional_resources", force: :cascade do |t|
    t.integer  "resource_id",            null: false
    t.integer  "additional_resource_id", null: false
    t.integer  "position"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "resource_additional_resources", ["additional_resource_id"], name: "index_resource_additional_resources_on_additional_resource_id", using: :btree
  add_index "resource_additional_resources", ["resource_id", "additional_resource_id"], name: "index_resource_additional_resources", unique: true, using: :btree

  create_table "resource_backups", force: :cascade do |t|
    t.string   "comment",    null: false
    t.string   "dump"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resource_downloads", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "download_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "active"
    t.integer  "download_category_id"
  end

  add_index "resource_downloads", ["download_category_id"], name: "index_resource_downloads_on_download_category_id", using: :btree
  add_index "resource_downloads", ["download_id"], name: "index_resource_downloads_on_download_id", using: :btree
  add_index "resource_downloads", ["resource_id"], name: "index_resource_downloads_on_resource_id", using: :btree

  create_table "resource_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "resource_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "resource_anc_desc_idx", unique: true, using: :btree
  add_index "resource_hierarchies", ["descendant_id"], name: "resource_desc_idx", using: :btree

  create_table "resource_reading_assignments", force: :cascade do |t|
    t.integer "resource_id",                null: false
    t.integer "reading_assignment_text_id", null: false
  end

  add_index "resource_reading_assignments", ["reading_assignment_text_id"], name: "idx_res_rea_asg_rea_asg_txt", using: :btree
  add_index "resource_reading_assignments", ["resource_id"], name: "index_resource_reading_assignments_on_resource_id", using: :btree

  create_table "resource_related_resources", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "related_resource_id"
    t.integer  "position"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "resource_related_resources", ["related_resource_id"], name: "index_resource_related_resources_on_related_resource_id", using: :btree
  add_index "resource_related_resources", ["resource_id"], name: "index_resource_related_resources_on_resource_id", using: :btree

  create_table "resource_requirements", force: :cascade do |t|
    t.integer  "resource_id",    null: false
    t.integer  "requirement_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_requirements", ["resource_id"], name: "index_resource_requirements_on_resource_id", using: :btree

  create_table "resource_slugs", force: :cascade do |t|
    t.integer "resource_id",                  null: false
    t.integer "curriculum_id"
    t.boolean "canonical",     default: true, null: false
    t.string  "value",                        null: false
  end

  add_index "resource_slugs", ["canonical"], name: "index_resource_slugs_on_canonical", using: :btree
  add_index "resource_slugs", ["curriculum_id"], name: "index_resource_slugs_on_curriculum_id", using: :btree
  add_index "resource_slugs", ["resource_id", "curriculum_id"], name: "resource_slugs_cur_canonical_unique", unique: true, where: "canonical", using: :btree
  add_index "resource_slugs", ["resource_id"], name: "index_resource_slugs_on_resource_id", using: :btree
  add_index "resource_slugs", ["value"], name: "index_resource_slugs_on_value", unique: true, using: :btree

  create_table "resource_standards", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "standard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_standards", ["resource_id"], name: "index_resource_standards_on_resource_id", using: :btree
  add_index "resource_standards", ["standard_id"], name: "index_resource_standards_on_standard_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "indexed_at"
    t.boolean  "hidden",                default: false
    t.string   "engageny_url"
    t.string   "engageny_title"
    t.string   "description"
    t.string   "title"
    t.string   "short_title"
    t.string   "subtitle"
    t.string   "teaser"
    t.integer  "time_to_teach"
    t.string   "subject"
    t.boolean  "ell_appropriate",       default: false, null: false
    t.datetime "deleted_at"
    t.integer  "resource_type",         default: 1,     null: false
    t.string   "url"
    t.string   "image_file"
    t.string   "curriculum_type"
    t.text     "curriculum_directory",  default: [],    null: false, array: true
    t.integer  "curriculum_tree_id"
    t.string   "hierarchical_position"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "level_position"
    t.boolean  "tree",                  default: false, null: false
  end

  add_index "resources", ["curriculum_tree_id"], name: "index_resources_on_curriculum_tree_id", using: :btree
  add_index "resources", ["deleted_at"], name: "index_resources_on_deleted_at", using: :btree
  add_index "resources", ["indexed_at"], name: "index_resources_on_indexed_at", using: :btree
  add_index "resources", ["resource_type"], name: "index_resources_on_resource_type", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.boolean  "editing_enabled",        default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "thumbnails_last_update"
  end

  create_table "social_thumbnails", force: :cascade do |t|
    t.integer "target_id",   null: false
    t.string  "target_type", null: false
    t.string  "image",       null: false
    t.string  "media",       null: false
  end

  add_index "social_thumbnails", ["target_type", "target_id"], name: "index_social_thumbnails_on_target_type_and_target_id", using: :btree

  create_table "staff_members", force: :cascade do |t|
    t.string   "bio",        limit: 4096
    t.string   "position"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "staff_type",              default: 1, null: false
    t.string   "image_file"
    t.string   "department"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "order"
  end

  add_index "staff_members", ["first_name", "last_name"], name: "index_staff_members_on_first_name_and_last_name", using: :btree

  create_table "standard_emphases", force: :cascade do |t|
    t.integer "standard_id", null: false
    t.string  "emphasis",    null: false
    t.string  "grade"
  end

  add_index "standard_emphases", ["standard_id"], name: "index_standard_emphases_on_standard_id", using: :btree

  create_table "standard_links", force: :cascade do |t|
    t.integer "standard_begin_id", null: false
    t.integer "standard_end_id",   null: false
    t.string  "link_type",         null: false
    t.string  "description"
  end

  add_index "standard_links", ["link_type"], name: "index_standard_links_on_link_type", using: :btree
  add_index "standard_links", ["standard_begin_id"], name: "index_standard_links_on_standard_begin_id", using: :btree
  add_index "standard_links", ["standard_end_id"], name: "index_standard_links_on_standard_end_id", using: :btree

  create_table "standard_strands", force: :cascade do |t|
    t.string "name",    null: false
    t.string "heading"
  end

  create_table "standards", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject",                                          null: false
    t.integer  "standard_strand_id"
    t.string   "asn_identifier"
    t.string   "description"
    t.text     "grades",                           default: [],    null: false, array: true
    t.string   "label"
    t.text     "alt_names",                        default: [],    null: false, array: true
    t.string   "type"
    t.integer  "cluster_id"
    t.integer  "domain_id"
    t.string   "language_progression_file"
    t.string   "language_progression_note"
    t.boolean  "is_language_progression_standard", default: false, null: false
  end

  add_index "standards", ["asn_identifier"], name: "index_standards_on_asn_identifier", unique: true, using: :btree
  add_index "standards", ["cluster_id"], name: "index_standards_on_cluster_id", using: :btree
  add_index "standards", ["domain_id"], name: "index_standards_on_domain_id", using: :btree
  add_index "standards", ["is_language_progression_standard"], name: "index_standards_on_is_language_progression_standard", using: :btree
  add_index "standards", ["name"], name: "index_standards_on_name", using: :btree
  add_index "standards", ["standard_strand_id"], name: "index_standards_on_standard_strand_id", using: :btree
  add_index "standards", ["subject"], name: "index_standards_on_subject", using: :btree
  add_index "standards", ["type"], name: "index_standards_on_type", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.integer  "role",                   default: 0,  null: false
    t.string   "access_code"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.hstore   "survey"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "content_guide_standards", "content_guides", on_delete: :cascade
  add_foreign_key "content_guide_standards", "standards"
  add_foreign_key "copyright_attributions", "resources"
  add_foreign_key "curriculums", "curriculum_types"
  add_foreign_key "curriculums", "curriculums", column: "parent_id"
  add_foreign_key "curriculums", "curriculums", column: "seed_id"
  add_foreign_key "document_parts", "documents"
  add_foreign_key "documents_materials", "documents"
  add_foreign_key "documents_materials", "materials"
  add_foreign_key "material_parts", "materials"
  add_foreign_key "reading_assignment_texts", "reading_assignment_authors"
  add_foreign_key "resource_additional_resources", "resources"
  add_foreign_key "resource_additional_resources", "resources", column: "additional_resource_id"
  add_foreign_key "resource_downloads", "download_categories", on_delete: :nullify
  add_foreign_key "resource_downloads", "downloads"
  add_foreign_key "resource_downloads", "resources"
  add_foreign_key "resource_reading_assignments", "reading_assignment_texts", name: "fk_res_rea_asg_rea_asg_txt"
  add_foreign_key "resource_reading_assignments", "resources"
  add_foreign_key "resource_related_resources", "resources"
  add_foreign_key "resource_related_resources", "resources", column: "related_resource_id"
  add_foreign_key "resource_slugs", "curriculums"
  add_foreign_key "resource_slugs", "resources"
  add_foreign_key "resource_standards", "resources"
  add_foreign_key "resource_standards", "standards"
  add_foreign_key "standard_emphases", "standards"
  add_foreign_key "standard_links", "standards", column: "standard_begin_id"
  add_foreign_key "standard_links", "standards", column: "standard_end_id"
  add_foreign_key "standards", "standard_strands"
  add_foreign_key "standards", "standards", column: "cluster_id"
  add_foreign_key "standards", "standards", column: "domain_id"
end
