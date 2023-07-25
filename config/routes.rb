Rails.application.routes.draw do
  resources :amazons
  resources :expresses
  resources :darazs
  devise_for :users
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get get '/compair', :to => 'home#compair'
end
