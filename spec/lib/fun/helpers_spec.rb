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

  describe '#fold' do
    it 'passes proc to foldable' do
      just_foldable    = FUN::Maybe.from_nil.call(10)
      nothing_foldable = FUN::Maybe.from_nil.call(nil)

      folder = fold.call(just: ->(x) { x * x },
                         nothing: ->(_) { 'Error' })

      expect(folder.call(just_foldable)).to eq 100
      expect(folder.call(nothing_foldable)).to eq 'Error'
    end
  end

  describe '#map' do
    it 'passes proc to mappable' do
      just_mappable    = FUN::Maybe.from_nil.call(10)
      nothing_mappable = FUN::Maybe.from_nil.call(nil)
      native_mappable  = [1, 7]

      mapper = map.call(->(x) { x + 5 })

      expect(mapper.call(just_mappable).fold).to eq 15
      expect(mapper.call(nothing_mappable).fold).to eq nil
      expect(mapper.call(native_mappable)).to eq [6, 12]
    end
  end

  describe '#flat_map' do
    it 'passes proc to flat_mappable' do
      just_flat_mappable    = FUN::Maybe.from_nil.call(10)
      nothing_flat_mappable = FUN::Maybe.from_nil.call(nil)
      native_flat_mappable  = [1, 7]

      flat_mapper = flat_map.call(->(x) { x + 5 })

      expect(flat_mapper.call(just_flat_mappable)).to eq 15
      expect(flat_mapper.call(nothing_flat_mappable).fold).to eq nil
      expect(flat_mapper.call(native_flat_mappable)).to eq [6, 12]
    end
  end

  describe '#reduce' do
    it 'passes init value and proc to reduceable' do
      reduceable = [1, 7]
      reducer    = reduce(0).call(->(acc, x) { acc + x })
      actual     = reducer.call(reduceable)
      expected   = 8
      expect(actual).to eq expected
    end
  end

  describe '#try_catch' do
    let(:divide_by_10) { ->(x) { x / 10 } }
    it 'returns a Just wrapped value for success' do
      actual     = try_catch.call(-> { divide_by_10.call(100) }).fold
      expected   = 10
      expect(actual).to eq expected
    end

    it 'returns a Nothing wrapped value for failure' do
      actual   = try_catch.call(-> { divide_by_10.call('DHH') })
                          .fold(nothing: ->(e) { e.to_s })
      expected = "undefined method `/' for \"DHH\":String"
      expect(actual).to eq expected
    end
  end
end
