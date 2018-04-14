# frozen_string_literal: true

class BusRoute < ApplicationRecord
  has_many :route_stops
  has_many :bus_stops, through: :route_stops

  validates :uuid, presence: true, uniqueness: true
end
