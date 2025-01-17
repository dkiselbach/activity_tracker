# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'user/sessions', registrations: 'user/registrations',
                                    passwords: 'user/passwords', confirmations: 'user/confirmations' }

  namespace :api do
    namespace :v1 do
      resources :activities
      resources :users
      resources :auth, only: %i[create index]
      delete 'auth', to: 'auth#disconnect'
      resources :subscriptions
      resources :biometrics, only: %i[create index]
    end
  end
end
