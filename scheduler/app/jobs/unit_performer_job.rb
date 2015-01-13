require 'resque/errors'

class UnitPerformerJob
  @queue = :units
  def self.perform(unit_id, history_id)
    unit      = Apify::Scheduler::Unit.find(unit_id)
    history   = Apify::Scheduler::History.find(history_id)
    history.update(queued: true)
    begin
      response  = unit.perform
      history.update finished_at: Time.zone.now, response_body: response
    rescue Resque::TermException
      # Log it
    end
  end
end