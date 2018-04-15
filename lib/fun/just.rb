# frozen_string_literal: true

require 'fun/helpers'
require 'fun/monad'

module FUN
  class Just < Monad
    include Helpers

    def map(fun)
      Just.of(fun&.call(value))
    end

    def flat_map(fun)
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
