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

ActiveRecord::Schema[7.0].define(version: 2022_01_07_142819) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"

  create_table "alternative_names", force: :cascade do |t|
    t.string "model_type"
    t.bigint "model_id"
    t.string "name"
    t.string "language"
    t.string "language_info"
    t.boolean "unusual", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_type", "model_id"], name: "index_alternative_names_on_model"
  end

  create_table "practitioners", force: :cascade do |t|
    t.bigint "created_style_id"
    t.string "name", null: false
    t.boolean "legendary", default: false
    t.boolean "controversial", default: false
    t.boolean "public_figure", default: false
    t.date "birthdate"
    t.boolean "approximate_birthdate", default: false
    t.date "deathdate"
    t.boolean "approximate_deathdate", default: false
    t.string "country_code", comment: "ISO 3166-1 alpha-2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "added_by_id"
    t.index ["added_by_id"], name: "index_practitioners_on_added_by_id"
    t.index ["created_style_id"], name: "index_practitioners_on_created_style_id"
    t.index ["deathdate"], name: "index_practitioners_on_deathdate"
    t.index ["name"], name: "index_practitioners_on_name"
    t.index ["public_figure"], name: "index_practitioners_on_public_figure"
    t.index ["user_id"], name: "index_practitioners_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "practitioner_id", null: false
    t.bigint "other_practitioner_id", null: false
    t.bigint "style_id", null: false
    t.string "relation_type", null: false, comment: "disciple/son/nephew/husband/..."
    t.integer "duration", comment: "in seconds"
    t.date "start_on"
    t.date "end_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["other_practitioner_id"], name: "index_relationships_on_other_practitioner_id"
    t.index ["practitioner_id"], name: "index_relationships_on_practitioner_id"
    t.index ["relation_type"], name: "index_relationships_on_relation_type"
    t.index ["style_id"], name: "index_relationships_on_style_id"
  end

  create_table "styles", force: :cascade do |t|
    t.string "name", null: false
    t.integer "practitioners_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_styles_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "practitioners", "styles", column: "created_style_id"
  add_foreign_key "practitioners", "users"
  add_foreign_key "practitioners", "users", column: "added_by_id"
  add_foreign_key "relationships", "practitioners"
  add_foreign_key "relationships", "practitioners", column: "other_practitioner_id"
  add_foreign_key "relationships", "styles"
end
