# frozen_string_literal: true

module FP
  def pipe
    lambda do |*funs|
      lambda do |x|
        funs.reduce(x) { |y, fun| fun.call(y) }
      end
    end
  end
end
