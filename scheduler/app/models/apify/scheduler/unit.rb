module Apify::Scheduler
  class Unit < ActiveRecord::Base
    require 'rest_client'
    require 'pry'
    validates :name, :pattern, :destination, :server, presence: true
    belongs_to :server, class_name: 'Apify::Scheduler::Server', foreign_key: :apify_scheduler_server_id
    belongs_to :frequency_period, class_name: 'Apify::Scheduler::FrequencyPeriod', foreign_key: :apify_scheduler_frequency_period_id

    has_many :histories, foreign_key: :apify_scheduler_unit_id

    def currently_working?
      Resque.working.map{ |w| w.job['payload']['args'].first }.include? self.id
    end

    def enqueue
      history = histories.create
      Resque.enqueue(UnitPerformerJob, self.id, history.id)
    end

    def perform
      begin
        json = pattern
        server_query = ["processes=#{processes}", "delay=#{delay}", "apify_secret=#{server.api_key}"].join('&')
        server_crawler_url = [server.url.chomp('/'), '/crawler'].join
        server_url = [server_crawler_url, server_query].join('?')

        request_resource = RestClient::Resource.new( server_url, timeout: 90000, open_timeout: 90000 )
        request = request_resource.post json, {:content_type => :json, :accept => :json}

        # TODO: record download attempts
        # request = JSON.parse(request)

        response_resource = RestClient::Resource.new( destination, timeout: 90000, open_timeout: 90000 )
        response_resource.post request, {:content_type => :json, :accept => :json}
      #rescue ActiveRecord, JSON, RestClient, Parallel, Errno, Errno::EPIPE, Errno::PIPE
      rescue Exception => e
        { success: 0, message: "#{e.class}: #{e.message}"}.to_json
      end
    end

    def frequency
      frequency_quantity.send(frequency_period.name.pluralize)
    end
  end
end
