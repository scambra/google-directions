module Google
  module Directions
    class Config
      include Singleton

      attr_accessor :client_id, :private_key, :timeout, :connect_timeout

      def timeout
        @timeout || 10
      end

      def connect_timeout
        @connect_timeout || 5
      end
    end
  end
end
