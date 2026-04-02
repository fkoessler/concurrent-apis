# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_02_125519) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "providers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  create_table "search_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}, null: false
    t.bigint "provider_id"
    t.bigint "search_id"
    t.datetime "updated_at", null: false
    t.index ["data"], name: "index_search_results_on_data", using: :gin
    t.index ["provider_id"], name: "index_search_results_on_provider_id"
    t.index ["search_id"], name: "index_search_results_on_search_id"
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "destination", null: false
    t.string "origin", null: false
    t.datetime "updated_at", null: false
  end
end
