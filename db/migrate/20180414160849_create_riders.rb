# frozen_string_literal: true

class CreateRiders < ActiveRecord::Migration[5.1]
  def change
    create_table :riders do |t|
      t.string :first_name
      t.string :last_name
      t.references :pickup_route_stop, index: true, foreign_key: { to_table: :route_stops }
      t.references :dropoff_route_stop, index: true, foreign_key: { to_table: :route_stops }
      t.timestamps
    end
  end
end
