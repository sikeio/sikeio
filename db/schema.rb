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

ActiveRecord::Schema.define(version: 20150323024201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json     "info"
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer  "enrollment_id"
    t.string   "lesson_name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "question"
    t.text     "solved_problem"
    t.string   "github_repository"
    t.integer  "degree_of_difficulty"
    t.integer  "time_cost"
  end

  add_index "checkouts", ["enrollment_id"], name: "index_checkouts_on_enrollment_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "version"
    t.datetime "start_time",  default: '2015-03-30 06:23:30', null: false
    t.datetime "enroll_time", default: '2015-03-30 06:23:30', null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "enrollments", ["course_id"], name: "index_enrollments_on_course_id", using: :btree
  add_index "enrollments", ["user_id"], name: "index_enrollments_on_user_id", using: :btree

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.text     "overview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "activation_token"
    t.json     "personal_info"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "has_been_activated", default: false
  end

end
