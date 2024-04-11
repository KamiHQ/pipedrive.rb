# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Pipedrive::Operations::Search do
  subject do
    Class.new(::Pipedrive::Base) do
      include ::Pipedrive::Operations::Search
    end.new('token')
  end

  describe '#search' do
    let(:additional_data) do
      { pagination: { more_items_in_collection?: true, next_start: 10 } }
    end
    let(:data_on_first_page) { { items: [ { result_score: 0.4, item: 1 },  { result_score: 0.3, item: 2 }] } }
    let(:data_on_last_page) { { items: [ { result_score: 0.2, item: 3 },  { result_score: 0.1, item: 4 }] } }

    it 'returns Enumerator if no block given' do
      expect(subject.search(term: 'bar')).to be_a(::Enumerator)
    end

    it 'calls to_enum with params' do
      expect(subject).to receive(:to_enum).with(:search, { term: 'bar' })
      subject.search(term: 'bar')
    end

    it 'yields data' do
      expect(subject).to receive(:search_chunk).with(term: 'bar', start: 0).and_return(::Hashie::Mash.new(data: data_on_first_page, success: true))
      expect { |b| subject.search(term: 'bar', &b) }.to yield_successive_args(1, 2)
    end

    it 'follows pagination' do
      expect(subject).to receive(:search_chunk).with(term: 'bar', start: 0).and_return(::Hashie::Mash.new(data: data_on_first_page, success: true, additional_data: additional_data))
      expect(subject).to receive(:search_chunk).with(term: 'bar', start: 10).and_return(::Hashie::Mash.new(data: data_on_last_page, success: true))
      expect { |b| subject.search(term: 'bar', &b) }.to yield_successive_args(1, 2, 3, 4)
    end

    it 'does not yield anything if result is empty' do
      expect(subject).to receive(:search_chunk).with(term: 'bar', start: 0).and_return(::Hashie::Mash.new(success: true))
      expect { |b| subject.search(term: 'bar', &b) }.to yield_successive_args
    end

    it 'does not yield anything if result is not success' do
      expect(subject).to receive(:search_chunk).with(term: 'bar', start: 0).and_return(::Hashie::Mash.new(success: false))
      expect { |b| subject.search(term: 'bar', &b) }.to yield_successive_args
    end
  end

  describe '#search_chunk' do
    it 'returns []' do
      res = double('res', success?: false)
      expect(subject).to receive(:make_api_call).with(:get, 'search', { term: 'bar' }).and_return(res)
      expect(subject.search_chunk(term: 'bar')).to eq([])
    end

    it 'returns result' do
      res = double('res', success?: true)
      expect(subject).to receive(:make_api_call).with(:get, 'search', { term: 'bar' }).and_return(res)
      expect(subject.search_chunk(term: 'bar')).to eq(res)
    end

    it 'raises if term is blank' do
      expect { subject.search_chunk({}) }.to raise_error(ArgumentError, 'term is missing')
    end
  end
end
