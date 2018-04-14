# frozen_string_literal: true

class RouteStop < ApplicationRecord
  belongs_to :bus_route
  belongs_to :bus_stop

  validates_presence_of :stop_time
end
