require 'spec_helper'

describe Google::Directions::Request do
  describe '#get' do
    let(:origin) { 'Rua Euclides Pacheco, 1035, São Paulo' }
    let(:destination) { 'Rua Frei Galvão, 69, São Paulo' }
    let(:params) do
      {
        origin: origin,
        destination: destination
      }
    end

    it 'should return a parsed JSON response' do
      VCR.use_cassette('get_directions_simple') do
        expect(subject.get(params)['status']).to eq 'OK'
      end
    end

    context 'when private key is set' do
      let(:url_with_key) { /^\S+key=\S+$/ }

      before do
        allow(Google::Directions.config).to receive(:private_key).and_return('MY_PRIVATE_KEY')
      end

      it 'should use key over HTTPS in request' do
        expect_any_instance_of(Patron::Session).to receive(:base_url=).with(/https/)
        expect_any_instance_of(Patron::Session).to receive(:get).with(url_with_key).once

        subject.get(params)
      end
    end

    context 'when is set to sign request' do
      let(:client_id) { 'my_client_id' }
      let(:private_key) { 'vNIXE0xscrmjlyV-12Nj_BvUPaw=' }
      let(:url_with_key) { /^\S+client=\S+\&signature=\S+$/ }

      before do
        allow(Google::Directions.config).to receive(:sign).and_return(true)
      end

      context 'when client_id and private_key are present' do
        before do
          allow(Google::Directions.config).to receive(:client_id).and_return(client_id)
          allow(Google::Directions.config).to receive(:private_key).and_return(private_key)
        end

        it 'should add signature to query string over HTTPS' do
          expect_any_instance_of(Patron::Session).to receive(:base_url=).with(/https/)
          expect_any_instance_of(Patron::Session).to receive(:get).with(url_with_key).once

          subject.get(params)
        end
      end

      context 'when client_id is missing' do
        it 'should raise an exception' do
          expect{subject.get(params)}.to raise_error Google::Directions::Error, 'Missing parameter: client_id'
        end
      end

      context 'when private_key is missing' do
        before do
          allow(Google::Directions.config).to receive(:client_id).and_return(client_id)
        end

        it 'should raise an exception' do
          expect{subject.get(params)}.to raise_error Google::Directions::Error, 'Missing parameter: private_key'
        end
      end
    end

    context 'when origin is missing' do
      let(:params) { { destination: 'Rua Frei Galvão, 69, São Paulo' } }

      it 'should raise an exception' do
        expect{subject.get(params)}.to raise_error Google::Directions::Error, 'Missing parameter: origin'
      end
    end

    context 'when destination is missing' do
      let(:params) { { origin: 'Rua Euclides Pacheco, 1035, São Paulo' } }

      it 'should raise an exception' do
        expect{subject.get(params)}.to raise_error Google::Directions::Error, 'Missing parameter: destination'
      end
    end

    context 'when there are waypoints' do
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
          expect(subject.get(params)['status']).to eq 'OK'
        end
      end

      context 'when addresses are geocoded' do
        let(:origin) { '-27.587036, -48.550418' }
        let(:destination) { '-27.437489, -48.399660' }
        let(:waypoints) do
          [
            '-27.554704, -48.500769',
            '-27.506827, -48.513965'
          ]
        end

        it 'should return a parsed JSON response' do
          VCR.use_cassette('get_geocoded_directions_with_waypoints') do
            expect(subject.get(params)['status']).to eq 'OK'
          end
        end
      end
    end
  end
end
