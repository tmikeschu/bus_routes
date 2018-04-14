# frozen_string_literal: true

require 'fun/helpers'
require 'fun/just'
require 'fun/nothing'

module FUN
  class Maybe
    class << self
      include Helpers

      def from_nil
        lambda { |value|
          (is_defined?.call(value) ? Just : Nothing).of(value)
        }
      end
    end
  end
end
