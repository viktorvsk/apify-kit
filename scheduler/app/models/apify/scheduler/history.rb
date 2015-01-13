module Apify::Scheduler
  class History < ActiveRecord::Base
    belongs_to :unit, class_name: 'Apify::Scheduler::Unit', foreign_key: :apify_scheduler_unit_id

    def currently_working?
      Resque.working.map{ |w| w.job['payload']['args'].last }.include? self.id
    end
  end
end
