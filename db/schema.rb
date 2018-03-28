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

ActiveRecord::Schema.define(version: 20180322144216) do
  create_table "achievements", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.string "status"
    t.boolean "payed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charges", force: :cascade do |t|
    t.string "charge_id"
    t.string "transfer_id"
    t.string "payment_id"
    t.string "balance_transaction_id"
    t.datetime "available_on"
    t.string "status"
    t.text "metadata"
    t.integer "proposal_id"
    t.boolean "captured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_charges_on_proposal_id"
  end

  create_table "client_profiles", force: :cascade do |t|
    t.text "about"
    t.text "url"
    t.text "industries"
    t.string "stripe_customer_id"
    t.boolean "verification", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_client_profiles_on_user_id"
  end

  create_table "connect_profiles", force: :cascade do |t|
    t.string "address_kana_city"
    t.string "address_kana_line1"
    t.string "address_kana_postal_code"
    t.string "address_kana_state"
    t.string "address_kana_town"
    t.string "address_kanji_city"
    t.string "address_kanji_line1"
    t.string "address_kanji_postal_code"
    t.string "address_kanji_state"
    t.string "address_kanji_town"
    t.string "dob_day"
    t.string "dob_month"
    t.string "dob_year"
    t.string "gender"
    t.string "first_name_kana"
    t.string "first_name_kanji"
    t.string "last_name_kana"
    t.string "last_name_kanji"
    t.string "phone_number"
    t.string "type"
    t.string "tos_acceptance_date"
    t.string "tos_acceptance_ip"
    t.text "verification"
    t.string "business_name"
    t.string "business_name_kana"
    t.string "business_name_kanji"
    t.string "business_tax_id"
    t.string "personal_address_kana_city"
    t.string "personal_address_kana_line1"
    t.string "personal_address_kana_postal_code"
    t.string "personal_address_kana_state"
    t.string "personal_address_kana_town"
    t.string "personal_address_kanji_city"
    t.string "personal_address_kanji_line1"
    t.string "personal_address_kanji_postal_code"
    t.string "personal_address_kanji_state"
    t.string "personal_address_kanji_town"
    t.string "stripe_account_id"
    t.string "stripe_secret_key"
    t.string "stripe_publishable_key"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "review"
    t.text "review_message"
    t.index ["user_id"], name: "index_connect_profiles_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string "title"
    t.integer "form_id"
    t.string "type"
    t.string "placeholder"
    t.string "value"
    t.integer "max_length"
    t.integer "min_length"
    t.integer "step"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "title"
    t.integer "task_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "template"
  end

  create_table "member_profiles", force: :cascade do |t|
    t.text "about"
    t.string "job_type"
    t.text "url"
    t.boolean "verification", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_member_profiles_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.boolean "unread"
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "reward"
    t.integer "proposal_id"
    t.integer "unit"
  end

  create_table "my_propositions", force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "group"
    t.string "avatar_url"
    t.integer "target_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link_url"
    t.integer "user_id"
    t.boolean "read", default: false, null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.datetime "paid_at"
    t.integer "reward"
    t.integer "unit"
    t.datetime "inspected_at"
  end

  create_table "room_keys", force: :cascade do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.boolean "validity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.boolean "closed"
    t.boolean "accepted"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "task_id"
    t.integer "target_user_id"
    t.integer "proposal_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "about"
    t.date "deadline"
    t.integer "views"
    t.integer "reward"
    t.integer "user_id"
    t.string "status"
    t.string "job_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "accepted_number"
    t.integer "base_number"
    t.integer "form_id"
    t.integer "unit"
    t.boolean "featured"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
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
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end
end
