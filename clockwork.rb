require 'clockwork'
require 'clockwork/database_events'
require_relative './config/boot'
require_relative './config/environment'

module Clockwork

  # required to enable database syncing support
  Clockwork.manager = DatabaseEvents::Manager.new

  sync_database_events model: Unit, every: 1.minute do |model_instance|

    model_instance.enqueue

  end


end