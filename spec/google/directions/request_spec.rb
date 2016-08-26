require 'spec_helper'

describe Google::Directions::Request do
  describe "#get" do
    let(:origin) { 'Rua Euclides Pacheco, 1035, São Paulo' }
    let(:destination) { 'Rua Frei Galvão, 69, São Paulo' }
    let(:params) do
      {
        origin: origin,
        destination: destination
      }
    end

    it "should return a parsed JSON response" do
      VCR.use_cassette('get_directions_simple') do
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

    context "when there are waypoints" do
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

      context "when addresses are geocoded" do
        let(:origin) { "-27.587036, -48.550418" }
        let(:destination) { "-27.437489, -48.399660" }
        let(:waypoints) do
          [
            "-27.554704, -48.500769",
            "-27.506827, -48.513965"
          ]
        end

        it 'should return a parsed JSON response' do
          VCR.use_cassette('get_geocoded_directions_with_waypoints') do
            expect(subject.get(params)['status']).to eq "OK"
          end
        end
      end
    end
  end
end
