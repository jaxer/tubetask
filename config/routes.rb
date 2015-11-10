Rails.application.routes.draw do
  apipie

  resources :organizations, only: [:index, :create]
  match 'organizations', :to => 'organizations#destroy_all', :via => :delete
  match 'relations/:id', :to => 'relations#index', :via => :get

  root :to => redirect('/docs')

  require 'sidekiq/web'
  mount Sidekiq::Web => '/jobs'
end
