# frozen_string_literal: true

require 'rails_helper'
require 'fun/nothing'

RSpec.describe FUN::Nothing do
  describe '.of' do
    it 'wraps an input value' do
      actual = FUN::Nothing.of(nil)
      expected = FUN::Nothing
      expect(actual).to be_a_kind_of expected
    end
  end

  describe 'fold' do
    it 'uses the identity function by default' do
      actual = FUN::Nothing.of(nil).fold
      expected = nil
      expect(actual).to eq expected
    end

    it 'returns an unwrapped result of the nothing function applied to the value' do
      actual = FUN::Nothing.of(nil).fold(nothing: ->(_) { 'Error' })
      expected = 'Error'
      expect(actual).to eq expected
    end
  end

  describe '#map' do
    it 'returns the same value wrapped in Nothing' do
      actual = FUN::Nothing.of(nil).map(->(x) { x + 5 }).fold
      expected = nil
      expect(actual).to eq expected
    end
  end

  describe '#flat_map' do
    it 'returns the same value wrapped in Nothing' do
      actual = FUN::Nothing.of(nil).flat_map(->(x) { FUN::Nothing.of(x + 5) }).fold
      expected = nil
      expect(actual).to eq expected
    end
  end
end
