# frozen_string_literal: true

require 'rails_helper'
require 'fun/maybe'

RSpec.describe FUN::Maybe do
  describe '.from_nil' do
    it 'returns a Just for non nil' do
      [1, '1', [1], { a: 1 }, :a].each do |input|
        actual   = FUN::Maybe.from_nil.call(input)
        expected = FUN::Just
        expect(actual).to be_a_kind_of expected
        expect(actual.fold).to eq input
      end
    end

    it 'returns a Nothing for nil' do
      actual   = FUN::Maybe.from_nil.call(nil)
      expected = FUN::Nothing
      expect(actual).to be_a_kind_of expected
      expect(actual.fold).to eq nil
    end

    describe '#fold' do
      it 'works on nil return value' do
        actual = FUN::Maybe.from_nil.call(nil).fold(
          nothing: ->(_) { 'Nada!' },
          just: ->(x) { x.upcase }
        )
        expected = 'Nada!'
        expect(actual).to eq expected
      end

      it 'works on non nil return value' do
        actual = FUN::Maybe.from_nil.call('hello').fold(
          nothing: ->(_) { 'Nada!' },
          just: ->(x) { x.upcase }
        )
        expected = 'HELLO'
        expect(actual).to eq expected
      end
    end
  end
end
