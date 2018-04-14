# frozen_string_literal: true

require 'fp/fp'

class BusRouteImporter
  class << self
    include FP
    def main(rows = [])
      puts rows
    end
  end
end
