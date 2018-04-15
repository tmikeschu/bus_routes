# frozen_string_literal: true

require 'rails_helper'
require 'fixtures/test_hash_array'

RSpec.describe BusRouteImporter do
  describe '.main' do
    describe 'for one row of data' do
      let(:data) { TEST_HASH_ARRAY[0...1] }
      it 'adds a rider, bus_routes, route_stops, and a bus_stop to the db' do
        expect { described_class.main.call(data) }
          .to change { Rider.count }
          .by(1)
          .and change { BusStop.count }
          .by(1)
          .and change { BusRoute.count }
          .by(2)
          .and change { RouteStop.count }
          .by(2)
      end

      it 'sets associations between Rider, BusStop, and BusRoute' do
        described_class.main.call(data)
        stop           = BusStop.first
        route1, route2 = BusRoute.first(2)
        route_stop1, route_stop2 = RouteStop.first(2)
        rider = Rider.first

        expect(stop.bus_routes).to include(route1, route2)

        expect(route1.bus_stops).to include(stop)
        expect(route2.bus_stops).to include(stop)

        expect(BusStop.all).to include(route_stop1.bus_stop)
        expect(BusRoute.all).to include(route_stop1.bus_route)
        expect(BusStop.all).to include(route_stop2.bus_stop)
        expect(BusRoute.all).to include(route_stop2.bus_route)

        expect([rider.pickup_route_stop_id, rider.dropoff_route_stop_id])
          .to match_array [route_stop1.id, route_stop2.id]
      end
    end

    describe 'for many rows of data' do
      let(:data) { TEST_HASH_ARRAY }
      it 'adds riders, bus_stops, bus_routes, and route_stops to the db' do
        expect { described_class.main.call(data) }
          .to change { Rider.count }
          .by(5)
          .and change { BusStop.count }
          .by(4)
          .and change { BusRoute.count }
          .by(6)
          .and change { RouteStop.count }
          .by(8)
      end
    end
  end
end
