# frozen_string_literal: true

class CreateBusRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :bus_routes do |t|
      t.string :uuid

      t.timestamps
    end
  end
end
