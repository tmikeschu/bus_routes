# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RouteStop do
  it { should belong_to(:bus_route) }
  it { should belong_to(:bus_route) }
  it { should have_db_column(:stop_time) }
  it { should validate_presence_of(:stop_time) }
end
