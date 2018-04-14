# frozen_string_literal: true

class CreateRouteStops < ActiveRecord::Migration[5.1]
  def change
    create_table :route_stops do |t|
      t.integer :bus_stop_id
      t.integer :bus_route_id
      t.time :stop_time

      t.timestamps
    end

    add_index :route_stops, %i[bus_stop_id bus_route_id]
  end
end
