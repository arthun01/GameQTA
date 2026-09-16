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

ActiveRecord::Schema[8.1].define(version: 2026_09_16_003408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_admins_on_email_address", unique: true
  end

  create_table "game_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "easy_time", default: 60, null: false
    t.integer "hard_time", default: 30, null: false
    t.integer "medium_time", default: 45, null: false
    t.datetime "updated_at", null: false
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

  create_table "question_submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_correct", default: false, null: false
    t.bigint "option_id"
    t.bigint "question_id", null: false
    t.datetime "revealed_at", null: false
    t.bigint "theme_attempt_id", null: false
    t.integer "time_taken"
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_question_submissions_on_option_id"
    t.index ["question_id"], name: "index_question_submissions_on_question_id"
    t.index ["theme_attempt_id", "question_id"], name: "index_question_submissions_on_theme_attempt_id_and_question_id", unique: true
    t.index ["theme_attempt_id"], name: "index_question_submissions_on_theme_attempt_id"
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

  create_table "theme_attempts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.bigint "theme_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["theme_id"], name: "index_theme_attempts_on_theme_id"
    t.index ["user_id", "theme_id"], name: "index_theme_attempts_on_user_id_and_theme_id", unique: true, where: "(status = 0)"
    t.index ["user_id"], name: "index_theme_attempts_on_user_id"
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

  create_table "user_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "age", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.integer "education_level", null: false
    t.string "email_address", null: false
    t.string "full_name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "options", "questions"
  add_foreign_key "question_submissions", "options"
  add_foreign_key "question_submissions", "questions"
  add_foreign_key "question_submissions", "theme_attempts"
  add_foreign_key "questions", "themes"
  add_foreign_key "sessions", "admins"
  add_foreign_key "theme_attempts", "themes"
  add_foreign_key "theme_attempts", "users"
  add_foreign_key "themes", "levels"
  add_foreign_key "user_sessions", "users"
end
