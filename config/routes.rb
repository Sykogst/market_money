Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  Rails.application.routes.draw do
    namespace :api do
      namespace :v0 do
        # get '/markets', to: 'markets#index'
        resources :markets, only: [:index]
      end
    end
  end
end
