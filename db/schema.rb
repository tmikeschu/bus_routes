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

ActiveRecord::Schema.define(version: 20180414160849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bus_routes", force: :cascade do |t|
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bus_stops", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "riders", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "pickup_route_stop_id"
    t.bigint "dropoff_route_stop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dropoff_route_stop_id"], name: "index_riders_on_dropoff_route_stop_id"
    t.index ["pickup_route_stop_id"], name: "index_riders_on_pickup_route_stop_id"
  end

  create_table "route_stops", force: :cascade do |t|
    t.integer "bus_stop_id"
    t.integer "bus_route_id"
    t.time "stop_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_stop_id", "bus_route_id"], name: "index_route_stops_on_bus_stop_id_and_bus_route_id"
  end

  add_foreign_key "riders", "route_stops", column: "dropoff_route_stop_id"
  add_foreign_key "riders", "route_stops", column: "pickup_route_stop_id"
end
