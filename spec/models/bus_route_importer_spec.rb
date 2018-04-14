# frozen_string_literal: true

require 'rails_helper'
require 'csv'
require 'fp/fp'

RSpec.describe BusRouteImporter do
  include FP
  describe '.main' do
    it 'adds riders, bus_routes, and bus_stops to the db' do
      test_rake_task = lambda do
        read = lambda { |filename|
          CSV.read(filename,
                   headers: true,
                   header_converters: :symbol)[0...1]
        }
        main = ->(rows) { BusRouteImporter.main(rows) }
        pipe.call(read, main).call('./db/bus_route_data.csv')
      end

      expect { test_rake_task.call }
        .to change { Rider.count }
        .by(1)
        .and change { BusStop.count }
        .by(1)
        .and change { BusRoute.count }
        .by(2)
    end
  end
end
