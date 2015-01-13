Rails.application.routes.draw do

  mount Scheduler::Engine => "/scheduler"
end
