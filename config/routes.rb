Rails.application.routes.draw do
  resources :organizations, except: [:new, :edit]
  root 'application#index'
end
