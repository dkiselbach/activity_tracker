Rails.application.routes.draw do
  get 'auth/authorize'
  get 'auth/access'
  get 'auth/refresh'
  get 'auth/strava/code', to: 'auth#code'
  root 'static_pages#home'
  get  '/home',    to: 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/setup',    to: 'static_pages#setup'
  get  '/about',    to: 'static_pages#about'
  get  '/contact',    to: 'static_pages#contact'
  devise_for :users
  resources :dashboard,     only: [:show]
end
