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

ActiveRecord::Schema.define(version: 20160201093904) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "go_links", force: :cascade do |t|
    t.string   "key"
    t.string   "url"
    t.string   "member_email"
    t.string   "description"
    t.string   "title"
    t.integer  "num_clicks"
    t.datetime "timestamp"
    t.string   "permissions"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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
  end

  create_table "tabling_slots", force: :cascade do |t|
    t.integer  "time"
    t.text     "member_emails"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
