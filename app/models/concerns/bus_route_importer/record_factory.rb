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

  def bus_stop_params(row, row_key)
    { address: row[row_key.to_sym] }
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

  def bus_route_params(row, row_key)
    { uuid: row[row_key.to_sym] }
  end

  def find_or_create_route_stop
    lambda do |row|
      row.merge(STOP_TYPES.reduce({}) do |acc, type|
        route_stop = RouteStop
          .find_or_initialize_by(route_stop_params(row, type))
        row_key = "#{type}_time"

        if route_stop.update!(stop_time: row[row_key.to_sym])
          acc.merge("#{type}_route_stop_id".to_sym => route_stop.id)
        else
          acc
        end
      end)
    end
  end

  def route_stop_params(row, type)
    { bus_stop_id: row["#{type}_bus_stop_id".to_sym],
      bus_route_id: row["#{type}_route_id".to_sym] }
  end

  def find_or_create_rider
    lambda do |row|
      rider = Rider.find_or_initialize_by(rider_params(row))

      if rider.update!(
        pickup_route_stop_id: row[:pickup_route_stop_id],
        dropoff_route_stop_id: row[:dropoff_route_stop_id]
      )
        row.merge(rider_id: rider.id)
      else
        row
      end
    end
  end

  def rider_params(row)
    { first_name: row[:first_name],
      last_name: row[:last_name] }
  end
end
