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

ActiveRecord::Schema.define(version: 20160515220536) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bobas", force: :cascade do |t|
    t.string   "name"
    t.integer  "sender_id"
    t.string   "order"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_members", force: :cascade do |t|
    t.string   "sender_id"
    t.string   "email"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "alias"
    t.string   "name"
    t.string   "partner"
    t.datetime "last_active"
    t.integer  "group_id"
    t.integer  "last_group_id"
    t.integer  "points"
  end

  create_table "clicks", force: :cascade do |t|
    t.string   "path"
    t.text     "params"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "properties"
    t.string   "name"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "semester"
    t.datetime "time"
    t.integer  "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "attended"
    t.text     "unattended"
  end

  create_table "go_link_clicks", force: :cascade do |t|
    t.string   "member_email"
    t.string   "key"
    t.string   "golink_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "go_link_groups", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "go_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "go_links", force: :cascade do |t|
    t.string   "key"
    t.string   "url"
    t.string   "member_email"
    t.string   "description"
    t.string   "title"
    t.integer  "num_clicks"
    t.datetime "timestamp"
    t.string   "permissions"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "semester"
    t.boolean  "is_deleted",   default: false, null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.string   "email"
    t.string   "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.string   "photo_url"
    t.string   "creator"
    t.string   "group_type"
    t.boolean  "is_open"
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "committee"
    t.string   "position"
    t.string   "major"
    t.string   "year"
    t.string   "latest_semester"
    t.string   "role"
    t.text     "commitments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gcm_id"
    t.string   "default_group"
    t.boolean  "is_active",       default: false, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "bot_member_id"
    t.string   "sender"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string   "member_email"
    t.string   "semester"
    t.string   "position"
    t.string   "committee"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "post_comments", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "member_email"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "post_groups", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "edit_permissions"
    t.string   "view_permissions"
    t.string   "folder"
    t.text     "content"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "semester"
    t.string   "last_editor"
    t.text     "tags"
    t.integer  "num_comments"
    t.string   "link"
  end

  create_table "pushes", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.string   "push_id"
    t.string   "author"
    t.string   "push_type"
    t.text     "response"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "member_emails"
  end

  create_table "tabling_slots", force: :cascade do |t|
    t.integer  "time"
    t.text     "member_emails"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tabling_switch_requests", force: :cascade do |t|
    t.string   "email1"
    t.string   "email2"
    t.string   "switch_status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "topics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "body"
    t.integer  "count"
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree
  add_index "visits", ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree

end
