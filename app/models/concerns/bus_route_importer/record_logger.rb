# frozen_string_literal: true

module BusRouteImporter::RecordLogger
  extend ActiveSupport::Concern

  private

  def filter_record_ids
    ->(row) { row.select { |k, _| k.to_s.include?('_id') } }
  end

  def group_record_types
    lambda do |row|
      init = { bus_stop: Set.new, route: Set.new, route_stop: Set.new, rider: Set.new }
      row.each_with_object(init) do |(k, v), acc|
        key = case k.to_s
              when /bus_stop/ then :bus_stop
              when /route_id/ then :route
              when /route_stop/ then :route_stop
              when /rider/ then :rider
              end
        acc[key] << v
      end
    end
  end

  def tally_records
    lambda do |acc, row|
      acc.merge(row) do |_, set1, set2|
        set1.merge(set2)
      end
    end
  end

  def print_results
    lambda do |record, set|
      puts "#{record.to_s.titleize}s added: #{set.size}, IDs: #{set.to_a}"
      [record, set.size]
    end
  end
end
