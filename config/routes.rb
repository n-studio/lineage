Rails.application.routes.draw do
  devise_for :users
  root to: "practitioners#index"
  get "/practitioners/search(/:search)", to: "practitioners#index", as: :practitioners_search
  get "/styles/search/:search", to: "styles#index"
  resources :practitioners do
    resources :masters, only: %i[new create]
    resources :disciples, only: %i[new create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
