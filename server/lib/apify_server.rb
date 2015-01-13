require 'sinatra'
require "apify_server/version"
require 'apify_core'

module Apify
  module Server

    class Node < Sinatra::Base
      set :apify_secret, ENV["APIFY_SECRET"]

      before do
        halt 403, {'Content-Type' => 'application/json'}, { status: 0, message: 'Setup API key'}.to_json if settings.apify_secret.nil? or settings.apify_secret.empty?
        content_type 'application/json'
        if params['apify_secret'] == settings.apify_secret
          pass
        else
          sleep(rand(1000...2000) / 1000)
          halt 403, {'Content-Type' => 'application/json'}, { status: 0, message: 'Invalid API key'}.to_json
        end

      end

      post '/crawler' do
        json = JSON.parse(request.body.read)
        response = Apify::Core.crawl!(json, params['processes'].to_i, params['delay'].to_i)
        if params['return'] and response.sources.include?(params['return'])
          response.send(params['return']).to_json
        else
          response.to_json
        end
      end

      post '/test-api-key' do
        { status: '1', message: 'API key is valid.' }.to_json
      end

      post '/parser' do
        json = JSON.parse(request.body.read)
        html = json['html']
        pattern = json['pattern']
        Apify::Core::Parser.new(html, pattern).perform.to_json
      end

    end
  end
end