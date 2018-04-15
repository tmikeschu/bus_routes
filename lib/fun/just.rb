# frozen_string_literal: true

require 'fun/helpers'
require 'fun/monad'

module FUN
  class Just < Monad
    include Helpers

    def map(fun = identity)
      return Just.of(yield(value)) if block_given?
      Just.of(fun&.call(value))
    end

    def flat_map(fun = identity)
      return yield(value) if block_given?
      fun&.call(value)
    end

    def fold(just: identity, nothing: nil)
      just&.call(value)
    end

    def inspect
      "Just(#{value})"
    end
  end
end
