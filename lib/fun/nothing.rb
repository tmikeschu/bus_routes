# frozen_string_literal: true

require 'fun/helpers'
require 'fun/monad'

module FUN
  class Nothing < Monad
    include Helpers

    def map(_)
      Nothing.of(value)
    end

    def flat_map(_)
      Nothing.of(value)
    end

    def fold(nothing: identity, just: nil)
      nothing.call(value)
    end

    def inspect
      "Nothing(#{value})"
    end
  end
end
