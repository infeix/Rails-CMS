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

ActiveRecord::Schema.define(version: 20170212135136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.text     "code"
    t.integer  "index"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "page_id"
    t.integer  "template_id"
  end

  add_index "articles", ["page_id"], name: "index_articles_on_page_id", using: :btree
  add_index "articles", ["template_id"], name: "index_articles_on_template_id", using: :btree

  create_table "page_parts", force: :cascade do |t|
    t.string   "title"
    t.integer  "index"
    t.text     "text"
    t.boolean  "is_last",     default: false
    t.string   "type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "template_id"
  end

  add_index "page_parts", ["template_id"], name: "index_page_parts_on_template_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.string   "path"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "template_id"
  end

  add_index "pages", ["template_id"], name: "index_pages_on_template_id", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "articles", "pages"
  add_foreign_key "articles", "templates"
  add_foreign_key "page_parts", "templates"
  add_foreign_key "pages", "templates"
end
