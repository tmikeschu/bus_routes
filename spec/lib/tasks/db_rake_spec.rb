# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe "Rake::Task['db:import_bus_route_data']" do
  # WHY DOES THE STDOUT STAY EMPTY STRING WHEN TESTS RUN TOGETHER?
  def task
    Rake::Task['db:import_bus_route_data']
  end

  before do
    load './lib/tasks/db.rake'
    Rake::Task.define_task(:environment)
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
    expect { task.invoke './spec/bus_route_test_data.csv' }.to_not output(expected).to_stdout
  end
end
