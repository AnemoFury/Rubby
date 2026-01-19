Rails.application.routes.draw do
  devise_for :users
  
  root "projects#index"

  resources :projects do
    resources :tasks do
      member do
        patch :move
        patch :assign
      end
    end
    member do
      patch :archive
    end
  end

  namespace :admin do
    resources :users
    resources :projects
  end

  # WebSocket route for ActionCable
  mount ActionCable.server => "/cable"
end
