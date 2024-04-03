Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root 'welcome#index'
  get '/register', to: 'users#new', as: 'register_user'
  get '/login', to: 'sessions#new', as: 'user_login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, only: %i[show new create] do
    resource :discover, only: %i[show]
    resources :movies, only: %i[index show] do
      resource :similar, only: %i[show]
      resources :viewing_parties, only: %i[create new show]
    end
  end

  namespace :admin do
    get '/dashboard', to: 'dashboard#index'
    resources :users, only: [:show]
  end
end
