# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rider do
  it { should have_db_column(:first_name) }
  it { should have_db_column(:last_name) }

  it { should belong_to(:pickup_route_stop) }
  it { should belong_to(:dropoff_route_stop) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:pickup_route_stop) }
  it { should validate_presence_of(:dropoff_route_stop) }
end
