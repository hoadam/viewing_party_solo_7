Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root 'welcome#index'
  get '/register', to: 'users#new', as: 'register_user'

  resources :users, only: %i[show create] do
    # get '/discover', to: 'users#discover', as: 'discover'
    resource :discover, only: %i[show]
    resources :movies, only: %i[index show] do
      resource :similar, only: %i[show]
      resources :viewing_parties, only: %i[create new show]
    end
  end
end
