Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # get "welcome/index" => "welcome#index", as: :welcome_index
  get "/" => "welcome#index", as: :welcome
  get "/gallery" => "gallery#index", as: :gallery
  get "/submit" => "submit#index", as: :submit
  post "/submit" => "submit#create", as: :submit_create
  get "/secret_code" => "secret_code#index", as: :secret_code
  get "/countdown", to: "countdown#index"
  namespace :api do
    get '/verify', to: 'verify#verify'
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
