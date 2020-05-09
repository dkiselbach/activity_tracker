Rails.application.routes.draw do
  get 'user/profile'
  get 'user/activities'
  root 'static_pages#home'
  get  '/home',    to: 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/setup',    to: 'static_pages#setup'
  devise_for :users
  resources :dashboard,     only: [:show]
end
