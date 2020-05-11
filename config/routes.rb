Rails.application.routes.draw do
  get 'oauth/authorize'
  get 'oauth/access'
  get 'oauth/refresh'
  get 'oauth/strava/auth_code', to: 'oauth#auth_code'
  root 'static_pages#home'
  get  '/home',    to: 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/setup',    to: 'static_pages#setup'
  get  '/about',    to: 'static_pages#about'
  get  '/contact',    to: 'static_pages#contact'
  devise_for :users
  resources :dashboard,     only: [:show]
end
