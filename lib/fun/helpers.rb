# frozen_string_literal: true

module FUN
  module Helpers
    def pipe
      lambda do |*funs|
        lambda do |x|
          funs.reduce(x) { |y, fun| fun.call(y) }
        end
      end
    end

    def identity
      ->(x) { x }
    end

    def is_defined?
      ->(x) { x.present? }
    end
  end
end
