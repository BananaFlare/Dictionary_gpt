Rails.application.routes.draw do
  get "user_interaction/include_words"
  get "user_interaction/exclude_words"
  root 'home#index'
  get    '/login',  to: 'sessions#authorisation'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resource :profile, only: :show, controller: 'users'

  get '/signup', to: 'users#new', as: 'signup'
  post '/users', to: 'users#create'

  get "up" => "rails/health#show", as: :rails_health_check
  post "/input_link",to: "input_link#accept_link"
  post "/selected_words", to: "user_interaction#exclude_words"
  resources :dictionaries do
  get :download_docx, on: :member  # URL: /dictionaries/:id/download_docx
  end
end
