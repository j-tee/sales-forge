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

ActiveRecord::Schema[7.0].define(version: 2023_06_01_110146) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_categories_on_store_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_customers_on_store_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "name"
    t.string "discount_type"
    t.decimal "discount_value"
    t.date "start_date"
    t.date "end_date"
    t.boolean "applicable"
    t.decimal "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone2"
    t.string "phone1"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_employees_on_store_id"
  end

  create_table "incident_reports", force: :cascade do |t|
    t.integer "product_id"
    t.string "incident_type"
    t.integer "qty"
    t.date "incident_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "type"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.index ["store_id"], name: "index_notifications_on_store_id"
  end

  create_table "order_line_items", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.decimal "total_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_line_items_on_order_id"
    t.index ["product_id"], name: "index_order_line_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status"
    t.decimal "total"
    t.bigint "customer_id", null: false
    t.bigint "employee_id", null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["stock_id"], name: "index_orders_on_stock_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "payment_type"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "product_discounts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "discount_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_product_discounts_on_discount_id"
    t.index ["product_id"], name: "index_product_discounts_on_product_id"
  end

  create_table "product_taxes", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "tax_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_taxes_on_product_id"
    t.index ["tax_id"], name: "index_product_taxes_on_tax_id"
  end

  create_table "products", force: :cascade do |t|
    t.decimal "unit_price"
    t.string "product_name"
    t.decimal "unit_cost"
    t.string "country"
    t.string "manufacturer"
    t.date "mnf_date"
    t.date "exp_date"
    t.integer "qty_in_stock"
    t.bigint "category_id", null: false
    t.text "description"
    t.string "supplier"
    t.integer "qty_sold"
    t.integer "total_expired"
    t.integer "qty_stolen"
    t.integer "qty_damaged"
    t.integer "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources_roles", force: :cascade do |t|
    t.bigint "resource_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_resources_roles_on_resource_id"
    t.index ["role_id"], name: "index_resources_roles_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.date "stock_date"
    t.bigint "store_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_stocks_on_store_id"
  end

  create_table "store_discounts", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "discount_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_store_discounts_on_discount_id"
    t.index ["store_id"], name: "index_store_discounts_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "email"
    t.string "phone1"
    t.string "phone2"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name"
    t.decimal "rate"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_taxes_on_store_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "volume_discounts", force: :cascade do |t|
    t.string "name"
    t.decimal "upper_limit"
    t.decimal "lower_limit"
    t.decimal "discount_value"
    t.boolean "percentage"
    t.boolean "applicable"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_volume_discounts_on_store_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "stores"
  add_foreign_key "customers", "stores"
  add_foreign_key "employees", "stores"
  add_foreign_key "notifications", "stores"
  add_foreign_key "order_line_items", "orders"
  add_foreign_key "order_line_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "employees"
  add_foreign_key "orders", "stocks"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_discounts", "discounts"
  add_foreign_key "product_discounts", "products"
  add_foreign_key "product_taxes", "products"
  add_foreign_key "product_taxes", "taxes"
  add_foreign_key "products", "categories"
  add_foreign_key "resources_roles", "resources"
  add_foreign_key "resources_roles", "roles"
  add_foreign_key "stocks", "stores"
  add_foreign_key "store_discounts", "discounts"
  add_foreign_key "store_discounts", "stores"
  add_foreign_key "stores", "users"
  add_foreign_key "taxes", "stores"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
  add_foreign_key "volume_discounts", "stores"
end
