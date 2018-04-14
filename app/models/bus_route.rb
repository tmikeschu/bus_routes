# frozen_string_literal: true

class BusRoute < ApplicationRecord
  has_many :route_stops
  has_many :bus_stops, through: :route_stops

  validates_presence_of :uuid
end
