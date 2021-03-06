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

ActiveRecord::Schema.define(version: 20151110150032) do

  create_table "organizations", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "external_id",      limit: 4
    t.datetime "sync_started_at"
    t.datetime "sync_finished_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "relations", force: :cascade do |t|
    t.integer  "relation_type",           limit: 4
    t.integer  "external_id",             limit: 4
    t.integer  "organization_id",         limit: 4
    t.integer  "related_organization_id", limit: 4
    t.datetime "sync_started_at"
    t.datetime "sync_finished_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "relations", ["organization_id"], name: "index_relations_on_organization_id", using: :btree
  add_index "relations", ["related_organization_id"], name: "index_relations_on_related_organization_id", using: :btree

end
