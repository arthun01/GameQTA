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

ActiveRecord::Schema[8.1].define(version: 2026_09_14_004617) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_admins_on_email_address", unique: true
  end

  create_table "levels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "icon"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.boolean "is_correct", default: false, null: false
    t.bigint "question_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "difficulty", default: 0, null: false
    t.text "feedback_article", null: false
    t.text "statement", null: false
    t.bigint "theme_id", null: false
    t.datetime "updated_at", null: false
    t.string "youtube_link", null: false
    t.index ["theme_id"], name: "index_questions_on_theme_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["admin_id"], name: "index_sessions_on_admin_id"
  end

  create_table "themes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.bigint "level_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["level_id"], name: "index_themes_on_level_id"
  end

  add_foreign_key "options", "questions"
  add_foreign_key "questions", "themes"
  add_foreign_key "sessions", "admins"
  add_foreign_key "themes", "levels"
end
