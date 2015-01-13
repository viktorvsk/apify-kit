Rails.application.routes.draw do

  devise_for :users
  mount Apify::Server::Node => '/apify'
  post '/test-response', to: 'github#blog'
  authenticate :user do
    root 'apify/scheduler/units#index'
    mount Apify::Scheduler::Engine => '/admin'
    mount ResqueWeb::Engine => "/resque"
  end
end
