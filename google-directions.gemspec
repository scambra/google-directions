# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google/directions/version'

Gem::Specification.new do |spec|
  spec.name          = "google-directions"
  spec.version       = Google::Directions::VERSION
  spec.authors       = ["Parafuzo Core Team"]
  spec.email         = ["dev@parafuzo.com"]
  spec.summary       = %q{Google directions.}
  spec.description   = %q{Google directions.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'    , '~> 1.6'
  spec.add_development_dependency 'rake'       , '~> 10.0'
  spec.add_development_dependency 'guard-rspec',  '~> 4.3', '>= 4.3.0'

  spec.add_runtime_dependency 'patron'        , '~> 0.4' , '>= 0.4.18'
  spec.add_runtime_dependency 'activesupport' , '>= 4.0'
end
