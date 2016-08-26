module Google
  module Directions
    class Request
      BASE_URL = 'http://maps.googleapis.com'
      GET_PATH = '/maps/api/directions/json'

      DRIVING_MODE = 'driving'

      attr_reader :params, :response

      def initialize
        session.base_url        = BASE_URL
        session.timeout         = Google::Directions.config.timeout
        session.connect_timeout = Google::Directions.config.connect_timeout
      end

      def get(params)
        @params   = params.with_indifferent_access
        @response = session.get GET_PATH + '?' + parse_params.to_query

        ::JSON.parse response.body
      end

      private

      def parse_params
        parsed_params = {
          sensor:      params[:sensor] || false,
          origin:      params[:origin] || missing(:origin),
          destination: params[:destination] || missing(:destination),
        }

        parsed_params[:waypoints] = parse_waypoints if params[:waypoints]
        parsed_params[:mode] = params[:mode] || DRIVING_MODE

        parsed_params
      end

      def parse_waypoints
        optimize = !!params[:optimize] || false
        waypoints = params[:waypoints].join('|')

        "optimize:#{optimize}|#{waypoints}"
      end

      def session
        @session ||= Patron::Session.new
      end

      def missing(name)
        raise Error, "Missing parameter: #{name}"
      end
    end
  end
end
