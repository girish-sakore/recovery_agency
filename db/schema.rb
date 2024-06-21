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

ActiveRecord::Schema[7.1].define(version: 2024_06_21_183746) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "allocation_drafts", force: :cascade do |t|
    t.string "segment"
    t.string "pool"
    t.string "branch"
    t.string "agreement_id"
    t.string "customer_name"
    t.string "pro"
    t.string "bkt"
    t.string "fos_name"
    t.string "fos_mobile_no"
    t.string "caller_name"
    t.string "caller_mo_number"
    t.string "f_code"
    t.date "ptp_date"
    t.string "feedback"
    t.string "res"
    t.integer "emi_coll"
    t.integer "cbc_coll"
    t.integer "total_coll"
    t.string "fos_id"
    t.string "mobile"
    t.string "address"
    t.string "zipcode"
    t.string "phone1"
    t.string "phone2"
    t.integer "loan_amt"
    t.string "pos"
    t.float "emi_amt"
    t.float "emi_od_amt"
    t.string "bcc_pending"
    t.string "penal_pending"
    t.integer "cycle"
    t.integer "tenure"
    t.date "disb_date"
    t.date "emi_start_date"
    t.date "emi_end_date"
    t.string "manufacturer_desc"
    t.string "asset_cat"
    t.string "supplier"
    t.string "system_bounce_reason"
    t.string "reference1_name"
    t.string "reference2_name"
    t.string "so_name"
    t.string "ro_name"
    t.string "all_dt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "caller_id"
    t.bigint "executive_id"
    t.index ["caller_id"], name: "index_allocation_drafts_on_caller_id"
    t.index ["executive_id"], name: "index_allocation_drafts_on_executive_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.text "column_preferences", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_user_preferences_on_admin_user_id"
  end

  add_foreign_key "allocation_drafts", "admin_users", column: "caller_id"
  add_foreign_key "allocation_drafts", "admin_users", column: "executive_id"
  add_foreign_key "user_preferences", "admin_users"
end
