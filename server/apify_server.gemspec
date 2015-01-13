# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apify_server/version'

Gem::Specification.new do |spec|
  spec.name          = "apify_server"
  spec.version       = Apify::Server::VERSION
  spec.authors       = ["victorvsk"]
  spec.email         = ["victor@vyskrebentsev.ru"]
  spec.summary       = %q{Apify Server is a part of Apify Project. It creates daemon using Sinatra.}
  spec.description   = %q{A simple way to create multiple nodes on any server to response on your Apify-Requests}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "apify_core", '0.1.2'
end
