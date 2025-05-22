Rails.application.routes.draw do
  root 'home#index'
  get    '/login',  to: 'sessions#authorisation'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resource :profile, only: :show, controller: 'users'

  get '/signup', to: 'users#new', as: 'signup'
  post '/users', to: 'users#create'

  get "up" => "rails/health#show", as: :rails_health_check
  post "/input_link",to: "input_link#accept_link"

  get 'admin/dashboard', to: 'admin#index', as: 'admin_dashboard'

  get 'admin/users', to: 'admin#users', as: 'admin_users'
  post 'admin/users/:id/toggle_block', to: 'admin#toggle_block', as: 'toggle_block_admin'
end
