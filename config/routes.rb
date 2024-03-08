Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :photos, only: [:show] do
    resources :photo_objects, only: [:index]
  end
end
