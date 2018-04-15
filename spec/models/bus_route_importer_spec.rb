# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe BusRouteImporter do
  describe '.main' do
    it 'adds riders, bus_routes, and bus_stops to the db' do
      # expectations based on 5 rows in spec/bus_route_test_data.csv
      expect { test_rake_task.call }
        .to change { Rider.count }
        .by(5)
        .and change { BusStop.count }
        .by(4)
        .and change { BusRoute.count }
        .by(6)
    end
  end

  def test_rake_task
    lambda do
      load './lib/tasks/db.rake'
      Rake::Task.define_task(:environment)

      Rake::Task['db:import_bus_route_data']
        .invoke './spec/bus_route_test_data.csv'
    end
  end
end
