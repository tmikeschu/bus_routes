# frozen_string_literal: true

namespace :db do
  desc 'ETL csv file to BusRoute, BusStop, and Rider models'
  task import_bus_route_data: :environment do
    unless filepath = ARGV[1]
      puts 'Please provide a filepath'
      next
    end

    require 'csv'
    require 'fp/fp'
    include FP

    read = lambda { |filename|
      CSV.read(filename,
               headers: true,
               header_converters: :symbol)
    }
    main = ->(rows) { BusRouteImporter.main(rows) }

    pipe.call(read, main).call(filepath)
  rescue StandardError => error
    message = "Error importing data: #{error}"
    Rails.logger.error message
    puts error.backtrace
    puts message
  end
end
