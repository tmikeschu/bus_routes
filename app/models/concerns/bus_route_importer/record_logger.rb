# frozen_string_literal: true

module BusRouteImporter::RecordLogger
  extend ActiveSupport::Concern

  private

  def filter_record_ids
    ->(row) { row.select { |k, _| k.to_s.include?('_id') } }
  end

  def group_record_types
    lambda do |row|
      init_groups = { bus_stop: Set.new, route: Set.new,
                      route_stop: Set.new, rider: Set.new }
      row.reduce(init_groups) do |acc, (k, v)|
        key = get_key_category(k)
        acc.merge(key => acc[key].clone.add(v))
      end
    end
  end

  def get_key_category(k)
    case k.to_s
    when /bus_stop/ then :bus_stop
    when /route_id/ then :route
    when /route_stop/ then :route_stop
    when /rider/ then :rider
    end
  end

  def tally_records
    ->(acc, row) { acc.merge(row) { |_, set1, set2| set1.merge(set2) } }
  end

  def print_results
    lambda do |record, set|
      puts "#{record.to_s.titleize}s added: #{set.size}, IDs: #{set.to_a}"
      [record, set.size]
    end
  end
end
