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

ActiveRecord::Schema.define(version: 20161020172802) do

  create_table "subscribers", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "service_id"
    t.boolean  "active"
    t.datetime "first_subscribed_at"
    t.datetime "last_subscribed_at"
    t.datetime "last_unsubscribed_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "sync_orders", force: :cascade do |t|
    t.string   "user_id"
    t.integer  "user_type"
    t.string   "product_id"
    t.string   "service_id"
    t.string   "services_list"
    t.integer  "update_type"
    t.string   "update_description"
    t.datetime "update_time"
    t.datetime "effective_time"
    t.datetime "expiry_time"
    t.string   "transaction_id"
    t.string   "order_key"
    t.integer  "mdspsubexpmode"
    t.integer  "object_type"
    t.boolean  "rent_success"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "traceunique_id"
  end

end
