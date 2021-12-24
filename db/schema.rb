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

ActiveRecord::Schema.define(version: 2021_12_24_072829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternative_names", force: :cascade do |t|
    t.string "model_type"
    t.bigint "model_id"
    t.string "name"
    t.string "language"
    t.string "language_info"
    t.boolean "unusual", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["model_type", "model_id"], name: "index_alternative_names_on_model"
  end

  create_table "practitioners", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "legendary", default: false
    t.boolean "controversial", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "practitioner_id", null: false
    t.bigint "other_practitioner_id", null: false
    t.bigint "style_id"
    t.string "relation_type", null: false, comment: "disciple/son/nephew/husband/..."
    t.integer "duration", comment: "in seconds"
    t.date "start_on"
    t.date "end_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["other_practitioner_id"], name: "index_relationships_on_other_practitioner_id"
    t.index ["practitioner_id"], name: "index_relationships_on_practitioner_id"
    t.index ["relation_type"], name: "index_relationships_on_relation_type"
    t.index ["style_id"], name: "index_relationships_on_style_id"
  end

  create_table "styles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "relationships", "practitioners"
  add_foreign_key "relationships", "practitioners", column: "other_practitioner_id"
  add_foreign_key "relationships", "styles"
end
