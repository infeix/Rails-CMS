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

ActiveRecord::Schema.define(version: 20190917115100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.float "starting_level"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.text "code"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "page_id"
    t.integer "template_element_id"
    t.string "position"
    t.string "image"
    t.string "video"
    t.string "type"
    t.string "target_path"
    t.string "data_text"
    t.string "pdf"
    t.index ["page_id"], name: "index_articles_on_page_id"
    t.index ["template_element_id"], name: "index_articles_on_template_element_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "phone"
    t.string "mail"
    t.string "bank_account_nr"
    t.string "bank_name"
    t.string "tax_nr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "content_parts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.text "code"
    t.integer "index"
    t.integer "template_element_id"
    t.string "position"
    t.string "image"
    t.string "video"
    t.string "type"
    t.string "target_path"
    t.string "data_text"
    t.string "pdf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "content_parts_pages", id: false, force: :cascade do |t|
    t.bigint "content_part_id", null: false
    t.bigint "page_id", null: false
  end

  create_table "document_templates", id: :serial, force: :cascade do |t|
    t.text "template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "to_id"
    t.integer "from_id"
    t.integer "document_template_id"
    t.date "send_date"
    t.index ["document_template_id"], name: "index_invoices_on_document_template_id"
    t.index ["from_id"], name: "index_invoices_on_from_id"
    t.index ["to_id"], name: "index_invoices_on_to_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "msg"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_parts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "index"
    t.text "text"
    t.boolean "is_last", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_element_id"
    t.index ["template_element_id"], name: "index_page_parts_on_template_element_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_element_id"
    t.integer "edit_filter"
    t.index ["template_element_id"], name: "index_pages_on_template_element_id"
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.integer "amount"
    t.string "unit"
    t.string "description"
    t.float "price_per_unit"
    t.integer "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_services_on_invoice_id"
  end

  create_table "template_elements", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "meta"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.float "total"
    t.string "name"
    t.date "invoice_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_id"
    t.integer "to_id"
    t.index ["from_id"], name: "index_transactions_on_from_id"
    t.index ["to_id"], name: "index_transactions_on_to_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "lang"
    t.string "name"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "is_subscriber"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "views", id: :serial, force: :cascade do |t|
    t.string "ref"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_views_on_page_id"
  end

  add_foreign_key "articles", "pages"
  add_foreign_key "articles", "template_elements"
  add_foreign_key "page_parts", "template_elements"
  add_foreign_key "pages", "template_elements"
  add_foreign_key "transactions", "accounts", column: "from_id"
  add_foreign_key "transactions", "accounts", column: "to_id"
end
