# frozen_string_literal: true

require 'rails_helper'
require 'fp/fp'

RSpec.describe 'Functional programming helpers' do
  include FP
  describe '#pipe' do
    it 'is a proc takes a list of procs and returns a proc' do
      a        = -> { 'a' }
      b        = -> { 'b' }
      actual   = pipe.call(a, b)
      expected = Proc
      expect(actual).to be_a_kind_of expected
    end

    it 'the returned proc takes a starting value and passes it through the procs' do
      a        = ->(x) { 'a' + x }
      d        = ->(x) { x + 'd' + x[1] }
      pipeline = pipe.call(a, d)
      actual   = pipeline.call('c')
      expected = 'acdc'
      expect(actual).to eq expected
    end
  end
end
