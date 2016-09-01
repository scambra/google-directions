require 'base64'
require 'digest/sha1'

module Google
  module Directions
    class Encoder
      attr_reader :uri_with_params, :private_key

      def initialize(uri_with_params, private_key)
        @uri_with_params = uri_with_params
        @private_key = private_key
      end

      def encode
        binary_key = Base64.decode64(private_key.tr('-_','+/'))
        digest = OpenSSL::Digest.new('sha1')
        signature  = OpenSSL::HMAC.digest(digest, binary_key, uri_with_params)
        signature = Base64.encode64(signature.tr('+/','-_')).tr("\n", '')

        "#{uri_with_params}&signature=#{signature}"
      end
    end
  end
end
