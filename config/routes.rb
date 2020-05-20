Rails.application.routes.draw do
  root 'static_pages#home'
  get 'auth/strava/code', to: 'auth#create'
  get  '/home',    to: 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/setup',    to: 'static_pages#setup'
  get  '/about',    to: 'static_pages#about'
  get  '/contact',    to: 'static_pages#contact'
  get '/sync_activities', to: 'static_pages#sync_activities'
  post 'activities', to: 'activity#create'
  post '/api/v1/login', to: 'users/sessions#create'
  devise_for :users, controllers: { sessions: 'user/sessions', registrations: 'user/registrations', passwords: "user/passwords"}

  namespace :api do
    namespace :v1 do
      resources :activities
      resources :users
    end
  end
end
