$:.unshift File.expand_path('../lib/', __dir__)

require 'active_support'
require 'active_support/core_ext'
require 'json'

module Google
  module Directions
    def self.config
      Config.instance
    end

    def self.configure(&block)
      block.call(self.config)
    end

    autoload :Config  , 'google/directions/config'
    autoload :Error   , 'google/directions/error'
    autoload :Request , 'google/directions/request'
    autoload :Version , 'google/directions/version'
  end
end
