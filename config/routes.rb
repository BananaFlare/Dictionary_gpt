Rails.application.routes.draw do
  Rails.application.routes.draw do
    root 'home#index'
  end
  get "up" => "rails/health#show", as: :rails_health_check
  post "/input_link",to: "input_link#accept_link"
  resources :dictionaries
end
