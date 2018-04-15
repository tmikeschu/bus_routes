# frozen_string_literal: true

require 'csv'
require 'fun/fun'
include FUN::Helpers

namespace :db do
  desc 'ETL csv file to BusRoute, BusStop, and Rider models'
  task :import_bus_route_data, [:filepath] => [:environment] do |_, args|
    read = lambda { |filename|
      CSV.read(filename,
               headers: true,
               header_converters: :symbol)
    }

    error_message = pipe.call(
      FUN::Maybe.from_nil,
      fold.call(nothing: ->(_) { 'Please provide a filepath' },
                just: ->(e) { ["Error: #{e}", e.backtrace[0]] })
    )

    import_file = pipe.call(
      FUN::Maybe.from_nil,
      flat_map.call(->(filepath) { try_catch.call(-> { read.call(filepath) }) }),
      map.call(->(rows) { rows.map(&:to_h) }),
      map.call(BusRouteImporter.main),
      fold.call(
        nothing: error_message
      )
    )

    pp import_file.call(args[:filepath])
  end
end
