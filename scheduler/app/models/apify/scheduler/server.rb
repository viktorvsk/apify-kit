module Apify::Scheduler
  class Server < ActiveRecord::Base
    validates :name, :url, :api_key, presence: true
    has_many :units, foreign_key: :apify_scheduler_server_id

    def test_api_key
      test_url = "#{url.chomp('/')}/test-api-key?apify_secret=#{api_key}"
      response = begin
        RestClient.post(test_url, {})
      rescue RestClient::ResourceNotFound => e
        { status: '0', message: e.message}.to_json
      end
      JSON.parse(response)
    end
  end
end
