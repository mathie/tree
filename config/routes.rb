Rails.application.routes.draw do
  resources :nodes

  root to: 'nodes#index'
end
