Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "demo", to: "demo#index"
  get "static_demo", to: "demo#static_index"
end
