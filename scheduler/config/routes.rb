Apify::Scheduler::Engine.routes.draw do
  root 'units#index'
  resources :units, :shallow => true do
    resources :histories, only: [:index, :destroy]
    member do
      post :perform
    end
  end
  resources :servers do
    member do
      post :test
    end
  end

end
