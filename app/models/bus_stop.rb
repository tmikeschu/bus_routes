# frozen_string_literal: true

class BusStop < ApplicationRecord
  has_many :route_stops
  has_many :bus_routes, through: :route_stops

  validates :address, presence: true, uniqueness: true
end
