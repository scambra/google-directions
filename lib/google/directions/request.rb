module Google
  module Directions
    class Request
      BASE_URL = 'http://maps.googleapis.com'
      GET_PATH = '/maps/api/directions/json'

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
        {
          sensor:      params[:sensor] || false,
          origin:      params[:origin],
          destination: params[:destination]
        }
      end

      def session
        @session ||= Patron::Session.new
      end
    end
  end
end
