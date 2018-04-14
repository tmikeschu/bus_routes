# frozen_string_literal: true

require 'rails_helper'
require 'fun/helpers'

RSpec.describe 'Functional programming helpers' do
  include FUN::Helpers

  describe '#pipe' do
    it 'is a proc takes a list of procs and returns a proc' do
      a = -> { 'a' }
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

  describe '#identity' do
    it 'returns the input' do
      [1, [1], { a: 1 }, 'a', :a].each do |input|
        actual   = identity.call(input)
        expected = input
        expect(actual).to eq expected
      end
    end
  end

  describe '#is_defined?' do
    it 'returns the false for nil' do
      actual   = is_defined?.call(nil)
      expected = false
      expect(actual).to eq expected
    end

    it 'returns the true for truthy values' do
      [1, [1], { a: 1 }, 'a', :a].each do |input|
        actual   = is_defined?.call(input)
        expected = true
        expect(actual).to eq expected
      end
    end
  end
end
