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

ActiveRecord::Schema[7.0].define(version: 2023_07_13_132153) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street_address"
    t.string "postal_code"
    t.string "address_locality"
  end

  create_table "carts", force: :cascade do |t|
    t.string "given_name"
    t.string "family_name"
    t.string "street_address"
    t.string "address_locality"
    t.string "postal_code"
    t.string "email"
    t.string "telephone"
    t.string "school"
    t.string "recipient"
    t.text "notes"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "user_id"
    t.string "given_name"
    t.string "family_name"
    t.integer "school_id"
    t.string "telephone"
    t.integer "address_id"
    t.integer "cart_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["address_id"], name: "index_customers_on_address_id"
    t.index ["cart_id"], name: "index_customers_on_cart_id"
    t.index ["school_id"], name: "index_customers_on_school_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id"
    t.string "state"
    t.string "tracking_number"
    t.date "shipping_date"
    t.text "notes"
    t.text "invoice_notes"
    t.string "email"
    t.string "given_name"
    t.string "family_name"
    t.text "extra_position"
    t.decimal "extra_price"
    t.integer "school_id"
    t.integer "invoice_address_id"
    t.integer "school_address_id"
    t.integer "cart_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "telephone"
    t.string "recipient"
    t.boolean "deliver_to_school", default: false
    t.boolean "terms_and_conditions_accepted"
    t.boolean "return_policy_read"
    t.datetime "deactivated_at", precision: nil
    t.integer "file_state", default: 0
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["invoice_address_id"], name: "index_orders_on_invoice_address_id"
    t.index ["school_address_id"], name: "index_orders_on_school_address_id"
    t.index ["school_id"], name: "index_orders_on_school_id"
  end

  create_table "positions", force: :cascade do |t|
    t.integer "product_variant_id"
    t.integer "amount"
    t.integer "position"
    t.integer "cart_id"
    t.decimal "unit_price"
    t.index ["cart_id"], name: "index_positions_on_cart_id"
    t.index ["product_variant_id"], name: "index_positions_on_product_variant_id"
  end

  create_table "product_subject_selections", force: :cascade do |t|
    t.integer "product_id"
    t.integer "subject_id"
    t.index ["product_id"], name: "index_product_subject_selections_on_product_id"
    t.index ["subject_id"], name: "index_product_subject_selections_on_subject_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.integer "product_id"
    t.boolean "teacher_edition"
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "description"
    t.decimal "price"
    t.decimal "reduced_price"
    t.string "year"
    t.string "image"
    t.decimal "weight"
    t.boolean "hide_teacher_edition", default: false
    t.boolean "hide_student_edition", default: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.integer "address_id"
    t.index ["address_id"], name: "index_schools_on_address_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "role"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.datetime "deactivated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customers", "carts"
  add_foreign_key "customers", "schools"
  add_foreign_key "customers", "users"
  add_foreign_key "orders", "carts"
  add_foreign_key "positions", "carts"
  add_foreign_key "positions", "product_variants"
  add_foreign_key "product_subject_selections", "products"
  add_foreign_key "product_subject_selections", "subjects"
  add_foreign_key "product_variants", "products"
end
