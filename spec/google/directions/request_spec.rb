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

    context "when there is waypoints" do
      let(:waypoints) do
        [
          'R. Serra de Bragança, 395 - Vila Gomes Cardim',
          'R. Padre Adelino, 445 - Quarta Parada'
        ]
      end

      before do
        params[:waypoints] = waypoints
      end

      it 'should return a parsed JSON response' do
        VCR.use_cassette('get_directions_with_waypoints') do
          expect(subject.get(params)['status']).to eq "OK"
        end
      end
    end
  end
end
