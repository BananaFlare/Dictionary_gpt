Rails.application.routes.draw do

  root 'home#index'
  get    '/login',  to: 'sessions#authorisation'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resource :profile, only: :show, controller: 'users'

  get '/signup', to: 'users#new', as: 'signup'
  post '/users', to: 'users#create'
  get '/profile', to: 'users#show', as: 'user_root'

  # post "/input_link",to: "input_link#accept_link"
  post "/input_link", to: "dictionaries#create"
  post "/dictionaries/:dict_id/exclude_words", to: "dictionaries#exclude_words"
  post "/dictionaries/:dict_id/docx", to: "dictionaries#docx"
  resources :dictionaries
end
