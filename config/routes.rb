Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'user/sessions', registrations: 'user/registrations',
                        passwords: "user/passwords", confirmations: "user/confirmations"}

  namespace :api do
    namespace :v1 do
      resources :activities
      resources :users
      resources :auth, only: [:create, :index]
      resources :subscriptions
      resources :profiles, only: [:create, :index]
    end
  end
end
