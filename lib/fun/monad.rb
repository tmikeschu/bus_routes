# frozen_string_literal: true

require 'fun/helpers'

module FUN
  class Monad
    def self.of(value)
      new(value)
    end

    def initialize(value)
      @value = value
    end

    def map(_)
      raise NotImplementedError
    end

    def flat_map(_)
      raise NotImplementedError
    end

    def fold(nothing: identity)
      raise NotImplementedError
    end

    def inspect
      raise NotImplementedError
    end

    private

    attr_reader :value
  end
end
