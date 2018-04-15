# frozen_string_literal: true

require 'fun/fun'

class BusRouteImporter
  STOP_TYPES = %w[pickup dropoff].freeze

  class << self
    include FUN::Helpers
    def main
      lambda { |rows|
        rows.map(&pipe.call(
          find_or_create_bus_stop,
          find_or_create_bus_route,
          find_or_create_route_stop,
          find_or_create_rider
        ))
      }
    end

    def find_or_create_bus_stop
      lambda do |row|
        STOP_TYPES.each do |type|
          row_key = "#{type}_bus_stop"
          row["#{row_key}_id".to_sym] = BusStop.find_or_create_by(
            address: row[row_key.to_sym]
          ).id
        end
        row
      end
    end

    def find_or_create_bus_route
      lambda do |row|
        STOP_TYPES.each do |type|
          row_key = "#{type}_route"
          row["#{row_key}_id".to_sym] = BusRoute.find_or_create_by(
            uuid: row[row_key.to_sym]
          ).id
        end
        row
      end
    end

    def find_or_create_route_stop
      lambda do |row|
        STOP_TYPES.each do |type|
          bus_stop_id  = row["#{type}_bus_stop_id".to_sym]
          bus_route_id = row["#{type}_route_id".to_sym]
          row_key = "#{type}_time"
          row["#{type}_route_stop_id".to_sym] = RouteStop.find_or_create_by(
            stop_time: row[row_key.to_sym],
            bus_stop_id: bus_stop_id,
            bus_route_id: bus_route_id
          ).id
        end

        row
      end
    end

    def find_or_create_rider
      lambda do |row|
        Rider.find_or_create_by(
          first_name: row[:first_name],
          last_name: row[:last_name],
          pickup_route_stop_id: row[:pickup_route_stop_id],
          dropoff_route_stop_id: row[:dropoff_route_stop_id]
        )
        row
      end
    end
  end
end
