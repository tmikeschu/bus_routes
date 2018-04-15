# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe "Rake::Task['db:import_bus_route_data']" do
  let(:task) { Rake::Task['db:import_bus_route_data'] }

  before do
    load './lib/tasks/db.rake'
    Rake::Task.define_task(:environment)
  end

  after do
    Rake::Task.clear
  end

  it 'returns an error for no file path' do
    expected = /Please provide a filepath/
    expect { task.invoke }.to output(expected).to_stdout
  end

  it 'returns an error for a bad file path' do
    expected = /Error: No such file or directory @ rb_sysopen - aaa/
    expect { task.invoke 'aaa' }.to output(expected).to_stdout
  end

  it 'returns an error for a non csv file path' do
    expected = /Error:/
    expect { task.invoke './lib/tasks/db.rake' }.to output(expected).to_stdout
  end

  it 'does not return an error for a good path' do
    expected = /Error:/
    expect { task.invoke './spec/fixtures/bus_route_data_test.csv' }
      .to_not output(expected).to_stdout
  end

  it 'adds records to the db' do
    expect { task.invoke './spec/fixtures/bus_route_data_test.csv' }
      .to change { Rider.count }
      .by(6)
      .and change { BusStop.count }
      .by(4)
      .and change { BusRoute.count }
      .by(6)
      .and change { RouteStop.count }
      .by(8)
  end
end
