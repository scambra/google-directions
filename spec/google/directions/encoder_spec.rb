require 'spec_helper'

describe Google::Directions::Encoder do
  describe '#encode' do

    let(:uri_with_params) { '/maps/api/geocode/json?address=Florianopolis&client=123' }
    let(:private_key) { 'vNIXE0xscrmjlyV-12Nj_BvUPaw=' }

    subject { described_class.new(uri_with_params, private_key).encode }

    it 'creates signature from path and query' do
      expect(subject).to eq("#{uri_with_params}&signature=NUtYTGR0ckF4TWZ4Vnp4ZUI0WDZTcG8tekI0PQ==")
    end
  end
end
