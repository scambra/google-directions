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

    context "when origin is missing" do
      let(:params) { { destination: 'Rua Frei Galvão, 69, São Paulo' } }

      it "should raise an exception" do
        expect{subject.get(params)}.to raise_error Google::Directions::Error, 'Missing parameter: origin'
      end
    end

    context "when destination is missing" do
      let(:params) { { origin: 'Rua Euclides Pacheco, 1035, São Paulo' } }

      it "should raise an exception" do
        expect{subject.get(params)}.to raise_error Google::Directions::Error, 'Missing parameter: destination'
      end
    end
  end
end
