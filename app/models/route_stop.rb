# frozen_string_literal: true

class RouteStop < ApplicationRecord
  belongs_to :bus_route
  belongs_to :bus_stop
  has_many :pickups,
           class_name: 'Rider',
           foreign_key: 'pickup_route_stop_id'
  has_many :dropoffs,
           class_name: 'Rider',
           foreign_key: 'dropoff_route_stop_id'

  validates_presence_of :stop_time
end
