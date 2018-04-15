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

    def fold
      ->(just: identity, nothing: identity) { ->(folder) { folder.fold(just: just, nothing: nothing) } }
    end

    def map
      ->(fun) { ->(mapper) { mapper.map(&fun) } }
    end

    def flat_map
      ->(fun) { ->(flat_mapper) { flat_mapper.flat_map(&fun) } }
    end

    def reduce(init = 0)
      ->(fun) { ->(reducer) { reducer.reduce(init, &fun) } }
    end

    def try_catch
      lambda do |fun|
        FUN::Just.of(fun.call)
      rescue StandardError => error
        FUN::Nothing.of(error)
      end
    end
  end
end
