Rails.application.routes.draw do
  devise_for :users
  
  root "dashboard#index"
  
  namespace :admin do
    resources :users, only: [:index] do
      member do
        patch :toggle_approved
      end
    end
  end
  
  resources :collections do
    collection do
      get :history
      get :invoice
    end
    member do
      patch :update_status
      patch :revert
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
