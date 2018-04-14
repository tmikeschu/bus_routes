# frozen_string_literal: true

class Rider < ApplicationRecord
  belongs_to :pickup_route_stop, class_name: 'RouteStop'
  belongs_to :dropoff_route_stop, class_name: 'RouteStop'

  validates_presence_of :dropoff_route_stop,
                        :last_name,
                        :pickup_route_stop,
                        :first_name
end
