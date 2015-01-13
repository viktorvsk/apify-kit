require 'active_support/all'
require 'watir-webdriver'
require 'rest_client'
require 'headless'
require 'parallel'
require 'nokogiri'

require "apify_core/version"
require "apify_core/parser"
require "apify_core/filter"
require "apify_core/fetcher"

module Apify
  module Core
    def self.crawl!( pages, processes=2, delay=0 )
      fetcher = Fetcher.new(pages.with_indifferent_access, processes, delay); nil
      fetcher.prepare; nil
      fetcher.perform; nil
      fetcher
    end

    def self.root
      File.expand_path '../..', __FILE__
    end
  end
end