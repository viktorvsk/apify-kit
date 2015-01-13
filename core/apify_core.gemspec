# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apify_core/version'

Gem::Specification.new do |spec|
  spec.name          = "apify_core"
  spec.version       = Apify::Core::VERSION
  spec.authors       = ["victorvsk"]
  spec.email         = ["victor@vyskrebentsev.ru"]
  spec.summary       = %q{Core part of Apify project. An easy way to parse HTML\XML content and crawl websites in a normalized and centralized way.}
  spec.description   = %q{Simple API to transform from simple HTML to JSON to entire website to JSON.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0.0"

  spec.add_dependency 'watir-webdriver', '~> 0.6.11'
  spec.add_dependency 'rest_client', '~> 1.8.2'
  spec.add_dependency 'headless', '~> 1.0.2'
  spec.add_dependency 'parallel', '~> 1.3.3'
  spec.add_dependency 'nokogiri', '~> 1.6.5'
  spec.add_dependency 'json', '~> 1.8.2'
  spec.add_dependency 'activesupport', '>= 3.0'

end
