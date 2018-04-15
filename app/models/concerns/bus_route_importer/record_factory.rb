# frozen_string_literal: true

module BusRouteImporter::RecordFactory
  extend ActiveSupport::Concern
  STOP_TYPES = %w[pickup dropoff].freeze

  private

  def find_or_create_records
    pipe.call(
      find_or_create_bus_stop,
      find_or_create_bus_route,
      find_or_create_route_stop,
      find_or_create_rider
    )
  end

  def find_or_create_bus_stop
    lambda do |row|
      STOP_TYPES.each do |type|
        row_key = "#{type}_bus_stop"
        if stop = BusStop.find_or_create_by(bus_stop_params(row, row_key))
          row["#{row_key}_id".to_sym] = stop.id
        end
      end
      row
    end
  end

  def find_or_create_bus_route
    lambda do |row|
      STOP_TYPES.each do |type|
        row_key = "#{type}_route"
        if route = BusRoute.find_or_create_by(bus_route_params(row, row_key))
          row["#{row_key}_id".to_sym] = route.id
        end
      end
      row
    end
  end

  def find_or_create_route_stop
    lambda do |row|
      STOP_TYPES.each do |type|
        if route_stop = RouteStop.find_or_create_by(route_stop_params(row, type))
          row["#{type}_route_stop_id".to_sym] = route_stop.id
        end
      end

      row
    end
  end

  def find_or_create_rider
    lambda do |row|
      if rider = Rider.find_or_create_by(rider_params(row))
        row[:rider_id] = rider.id
      end

      row
    end
  end

  def bus_stop_params(row, row_key)
    { address: row[row_key.to_sym] }
  end

  def bus_route_params(row, row_key)
    { uuid: row[row_key.to_sym] }
  end

  def route_stop_params(row, type)
    row_key = "#{type}_time"
    bus_stop_id  = row["#{type}_bus_stop_id".to_sym]
    bus_route_id = row["#{type}_route_id".to_sym]
    { stop_time: row[row_key.to_sym],
      bus_stop_id: bus_stop_id,
      bus_route_id: bus_route_id }
  end

  def rider_params(row)
    { first_name: row[:first_name],
      last_name: row[:last_name],
      pickup_route_stop_id: row[:pickup_route_stop_id],
      dropoff_route_stop_id: row[:dropoff_route_stop_id] }
  end
end
