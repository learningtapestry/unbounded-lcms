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

ActiveRecord::Schema.define(version: 20160229141346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alignments", force: :cascade do |t|
    t.string   "name"
    t.string   "framework"
    t.string   "framework_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alignments", ["framework"], name: "index_alignments_on_framework", using: :btree
  add_index "alignments", ["framework_url"], name: "index_alignments_on_framework_url", using: :btree

  create_table "curriculum_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "curriculum_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "curriculum_anc_desc_idx", unique: true, using: :btree
  add_index "curriculum_hierarchies", ["descendant_id"], name: "curriculum_desc_idx", using: :btree

  create_table "curriculum_types", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "curriculums", force: :cascade do |t|
    t.integer "curriculum_type_id", null: false
    t.integer "parent_id"
    t.integer "position"
    t.integer "item_id",            null: false
    t.string  "item_type",          null: false
  end

  add_index "curriculums", ["curriculum_type_id"], name: "index_curriculums_on_curriculum_type_id", using: :btree
  add_index "curriculums", ["item_id"], name: "index_curriculums_on_item_id", using: :btree
  add_index "curriculums", ["item_type"], name: "index_curriculums_on_item_type", using: :btree
  add_index "curriculums", ["parent_id"], name: "index_curriculums_on_parent_id", using: :btree

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
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "google_doc_definitions", force: :cascade do |t|
    t.string   "keyword",     null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "google_doc_definitions", ["keyword"], name: "index_google_doc_definitions_on_keyword", unique: true, using: :btree

  create_table "google_doc_images", force: :cascade do |t|
    t.string   "file",         null: false
    t.string   "original_url", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "google_doc_images", ["original_url"], name: "index_google_doc_images_on_original_url", unique: true, using: :btree

  create_table "google_doc_standards", force: :cascade do |t|
    t.string "description", null: false
    t.string "name",        null: false
  end

  add_index "google_doc_standards", ["name"], name: "index_google_doc_standards_on_name", unique: true, using: :btree

  create_table "google_docs", force: :cascade do |t|
    t.string   "content",          null: false
    t.string   "file_id",          null: false
    t.string   "name",             null: false
    t.string   "original_content", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "google_docs", ["file_id"], name: "index_google_docs_on_file_id", unique: true, using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.text     "body",       null: false
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  create_table "resource_additional_resources", force: :cascade do |t|
    t.integer  "resource_id",            null: false
    t.integer  "additional_resource_id", null: false
    t.integer  "position"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "resource_additional_resources", ["additional_resource_id"], name: "index_resource_additional_resources_on_additional_resource_id", using: :btree
  add_index "resource_additional_resources", ["resource_id", "additional_resource_id"], name: "index_resource_additional_resources", unique: true, using: :btree

  create_table "resource_alignments", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "alignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_alignments", ["alignment_id"], name: "index_resource_alignments_on_alignment_id", using: :btree
  add_index "resource_alignments", ["resource_id"], name: "index_resource_alignments_on_resource_id", using: :btree

  create_table "resource_children", force: :cascade do |t|
    t.integer  "parent_id",              null: false
    t.integer  "child_id",               null: false
    t.integer  "position",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "resource_collection_id", null: false
  end

  add_index "resource_children", ["child_id"], name: "index_resource_children_on_child_id", using: :btree
  add_index "resource_children", ["parent_id"], name: "index_resource_children_on_parent_id", using: :btree
  add_index "resource_children", ["resource_collection_id", "child_id"], name: "index_resource_children_on_resource_collection_id_and_child_id", unique: true, using: :btree

  create_table "resource_collection_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "resource_collection_types", ["name"], name: "index_resource_collection_types_on_name", unique: true, using: :btree

  create_table "resource_collections", force: :cascade do |t|
    t.integer  "resource_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "resource_collection_type_id"
  end

  add_index "resource_collections", ["resource_collection_type_id"], name: "index_resource_collections_on_resource_collection_type_id", using: :btree
  add_index "resource_collections", ["resource_id"], name: "index_resource_collections_on_resource_id", using: :btree

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

  create_table "resource_grades", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "grade_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "resource_grades", ["grade_id"], name: "index_resource_grades_on_grade_id", using: :btree
  add_index "resource_grades", ["resource_id"], name: "index_resource_grades_on_resource_id", using: :btree

  create_table "resource_related_resources", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "related_resource_id"
    t.integer  "position"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "resource_related_resources", ["related_resource_id"], name: "index_resource_related_resources_on_related_resource_id", using: :btree
  add_index "resource_related_resources", ["resource_id"], name: "index_resource_related_resources_on_resource_id", using: :btree

  create_table "resource_resource_types", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "resource_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "resource_resource_types", ["resource_id"], name: "index_resource_resource_types_on_resource_id", using: :btree
  add_index "resource_resource_types", ["resource_type_id"], name: "index_resource_resource_types_on_resource_type_id", using: :btree

  create_table "resource_slugs", force: :cascade do |t|
    t.integer  "resource_id",            null: false
    t.integer  "resource_collection_id"
    t.string   "value",                  null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "resource_slugs", ["resource_collection_id"], name: "index_resource_slugs_on_resource_collection_id", using: :btree
  add_index "resource_slugs", ["resource_id", "resource_collection_id"], name: "index_resource_slugs_on_resource_id_and_resource_collection_id", unique: true, using: :btree
  add_index "resource_slugs", ["value"], name: "index_resource_slugs_on_value", unique: true, using: :btree

  create_table "resource_subjects", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_subjects", ["resource_id"], name: "index_resource_subjects_on_resource_id", using: :btree
  add_index "resource_subjects", ["subject_id"], name: "index_resource_subjects_on_subject_id", using: :btree

  create_table "resource_topics", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "topic_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "resource_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "resource_types", ["name"], name: "index_resource_types_on_name", using: :btree

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "indexed_at"
    t.boolean  "hidden",         default: false
    t.string   "engageny_url"
    t.string   "engageny_title"
    t.string   "description"
    t.string   "title"
    t.string   "short_title"
    t.string   "subtitle"
  end

  add_index "resources", ["indexed_at"], name: "index_resources_on_indexed_at", using: :btree

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
  end

  add_index "subjects", ["name"], name: "index_subjects_on_name", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["name"], name: "index_topics_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",                  default: true, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "curriculums", "curriculum_types"
  add_foreign_key "curriculums", "curriculums", column: "parent_id"
  add_foreign_key "resource_additional_resources", "resources"
  add_foreign_key "resource_additional_resources", "resources", column: "additional_resource_id"
  add_foreign_key "resource_alignments", "alignments"
  add_foreign_key "resource_alignments", "resources"
  add_foreign_key "resource_children", "resource_collections"
  add_foreign_key "resource_children", "resources", column: "child_id"
  add_foreign_key "resource_children", "resources", column: "parent_id"
  add_foreign_key "resource_collections", "resource_collection_types"
  add_foreign_key "resource_collections", "resources"
  add_foreign_key "resource_downloads", "download_categories"
  add_foreign_key "resource_downloads", "downloads"
  add_foreign_key "resource_downloads", "resources"
  add_foreign_key "resource_grades", "grades"
  add_foreign_key "resource_grades", "resources"
  add_foreign_key "resource_related_resources", "resources"
  add_foreign_key "resource_related_resources", "resources", column: "related_resource_id"
  add_foreign_key "resource_resource_types", "resource_types"
  add_foreign_key "resource_resource_types", "resources"
  add_foreign_key "resource_slugs", "resource_collections"
  add_foreign_key "resource_slugs", "resources"
  add_foreign_key "resource_subjects", "resources"
  add_foreign_key "resource_subjects", "subjects"
end
