# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Pipedrive::File do
  let(:connection) { Faraday.new }
  let(:pipedrive_response) { Hashie::Mash.new(success: true, data: { id: 1 }) }

  subject { described_class.new('token') }

  describe '#entity_name' do
    subject { super().entity_name }

    it { is_expected.to eq('files') }
  end

  describe '#create_remote' do
    let(:params) { { file_type: :gdoc, title: 'google doc', item_id: 1, remote_id: 'remote_id', remote_location: :googledrive } }

    it 'sends request to /v1/files/remote' do
      expect(subject).to receive(:connection).and_return(connection)
      expect(connection).to receive(:post).with('/v1/files/remote?api_token=token', params.to_json).and_return(pipedrive_response)
      subject.create_remote(**params)
    end
  end

  describe '#create_remote_link' do
    let(:params) { { item_type: :deal, item_id: 1, remote_id: 'remote_id', remote_location: :googledrive } }

    it 'sends request to /v1/files/remoteLink' do
      expect(subject).to receive(:connection).and_return(connection)
      expect(connection).to receive(:post).with('/v1/files/remoteLink?api_token=token', params.to_json).and_return(pipedrive_response)
      subject.create_remote_link(**params)
    end
  end
end
