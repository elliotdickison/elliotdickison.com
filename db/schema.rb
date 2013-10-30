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

ActiveRecord::Schema.define(version: 20131030185441) do

  create_table "comments", force: true do |t|
    t.string   "commenter"
    t.string   "email"
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference_id"
    t.datetime "published_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_files", force: true do |t|
    t.string   "name"
    t.string   "extension"
    t.binary   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_files", ["name", "extension"], name: "by_file_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password"
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
