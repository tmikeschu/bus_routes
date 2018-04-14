# frozen_string_literal: true

require 'rails_helper'
require 'fun/just'

RSpec.describe FUN::Just do
  describe '.of' do
    it 'wraps an input value' do
      actual = FUN::Just.of(5)
      expected = FUN::Just
      expect(actual).to be_a_kind_of expected
    end
  end

  describe 'fold' do
    it 'uses the identity function by default' do
      actual = FUN::Just.of(5).fold
      expected = 5
      expect(actual).to eq expected
    end

    it 'returns an unwrapped result of the just function applied to the value' do
      actual = FUN::Just.of(5).fold(just: ->(x) { x * 10 })
      expected = 50
      expect(actual).to eq expected
    end
  end

  describe '#map' do
    it 'applies the proc to the value and returns it in a Just' do
      actual = FUN::Just.of(5).map(->(x) { x + 5 }).fold
      expected = 10
      expect(actual).to eq expected
    end
  end

  describe '#flat_map' do
    it 'applies a proc to the value' do
      actual = FUN::Just.of(5).flat_map(->(x) { FUN::Just.of(x + 5) }).fold
      expected = 10
      expect(actual).to eq expected
    end
  end
end
