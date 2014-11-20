require 'spec_helper'

describe Google::Directions::Request do
  describe "#get" do
    let(:params) { {
      origin:      'Rua Euclides Pacheco, 1035, São Paulo',
      destination: 'Rua Frei Galvão, 69, São Paulo'
    } }

    it "should return a parsed JSON response" do
      VCR.use_cassette('request_get') do
        expect(subject.get(params)['status']).to eq "OK"
      end
    end
  end
end
