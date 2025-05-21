Rails.application.routes.draw do
  Rails.application.routes.draw do
    root 'home#index'
    get    '/login',  to: 'sessions#new'
    post   '/login',  to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    resource :profile, only: :show, controller: 'users'
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  post "/input_link",to: "input_link#accept_link"
end
