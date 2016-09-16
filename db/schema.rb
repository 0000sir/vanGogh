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

ActiveRecord::Schema.define(version: 20160916061317) do

  create_table "artworks", force: :cascade do |t|
    t.string   "source_file_name"
    t.string   "source_content_type"
    t.integer  "source_file_size"
    t.datetime "source_updated_at"
    t.string   "source_fingerprint"
    t.string   "openid"
    t.integer  "style_id"
    t.string   "output_file_name"
    t.string   "output_content_type"
    t.integer  "output_file_size"
    t.datetime "output_updated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "media_id"
    t.string   "decorated_output_file_name"
    t.string   "decorated_output_content_type"
    t.integer  "decorated_output_file_size"
    t.datetime "decorated_output_updated_at"
  end

  create_table "styles", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_fingerprint"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.boolean  "subscribe"
    t.string   "openid"
    t.string   "nickname"
    t.integer  "sex"
    t.string   "language"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "headimgurl"
    t.string   "subscribe_time"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "wechat_sessions", force: :cascade do |t|
    t.string   "openid",     null: false
    t.string   "hash_store"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openid"], name: "index_wechat_sessions_on_openid", unique: true
  end

end
