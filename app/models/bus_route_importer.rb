# frozen_string_literal: true

require 'fun/fun'

class BusRouteImporter
  include RecordLogger
  include RecordFactory
  include FUN::Helpers

  def self.main
    new.main
  end

  def main
    pipe.call(
      map.call(find_or_create_records),
      map.call(filter_record_ids),
      map.call(group_record_types),
      reduce({}).call(tally_records),
      map.call(print_results)
    )
  end
end
