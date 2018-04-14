# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusStop do
  it { should have_db_column(:address) }
  it { should have_many(:route_stops) }
  it { should have_many(:bus_routes).through(:route_stops) }
end
