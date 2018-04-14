# frozen_string_literal: true

class BusStop < ApplicationRecord
  has_many :route_stops
  has_many :bus_routes, through: :route_stops

  validates_presence_of :address
end
