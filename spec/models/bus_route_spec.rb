# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusRoute do
  it { should have_many(:route_stops) }
  it { should have_many(:bus_stops).through(:route_stops) }
  it { should have_db_column(:uuid) }
  it { should validate_presence_of(:uuid) }
end
