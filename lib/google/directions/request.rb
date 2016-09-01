module Google
  module Directions
    class Request
      BASE_URL = 'maps.googleapis.com'
      GET_PATH = '/maps/api/directions/json'

      DRIVING_MODE = 'driving'

      attr_reader :params, :response

      def initialize
        session.base_url        = ((sign? || private_key) ? 'https://' : 'http://') + BASE_URL
        session.timeout         = Google::Directions.config.timeout
        session.connect_timeout = Google::Directions.config.connect_timeout
      end

      def get(params)
        @params   = params.with_indifferent_access

        url = sign_url_if_needed(GET_PATH + '?' + parse_params.to_query)
        @response = session.get url

        response ? ::JSON.parse(response.body) : nil
      end

      private

      def parse_params
        parsed_params = {
          sensor:      params[:sensor] || false,
          origin:      params[:origin] || missing(:origin),
          destination: params[:destination] || missing(:destination)
        }

        parsed_params[:waypoints] = parse_waypoints if params[:waypoints]
        parsed_params[:mode] = params[:mode] || DRIVING_MODE

        set_auth_params!(parsed_params)

        parsed_params
      end

      def sign_url_if_needed(uri_with_params)
        sign? ? Encoder.new(uri_with_params, private_key).encode : uri_with_params
      end

      def parse_waypoints
        optimize = !!params[:optimize] || false
        waypoints = params[:waypoints].join('|')

        "optimize:#{optimize}|#{waypoints}"
      end

      def set_auth_params!(parsed_params)
        if sign?
          missing('client_id') unless client_id
          missing('private_key') unless private_key

          parsed_params[:client] = client_id
        elsif private_key
          parsed_params[:key] = private_key
        end
      end

      def session
        @session ||= Patron::Session.new
      end

      def missing(name)
        raise Error, "Missing parameter: #{name}"
      end

      def private_key
        Google::Directions.config.private_key
      end

      def client_id
        Google::Directions.config.client_id
      end

      def sign?
        Google::Directions.config.sign
      end
    end
  end
end
