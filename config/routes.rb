Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  Rails.application.routes.draw do
    namespace :api do
      namespace :v0 do
        get '/markets/search', to: 'markets/search#markets'
        resources :markets, only: [:index, :show] do
          resources :vendors, only: [:index], controller: 'market_vendors'
        end

        resources :vendors, only: [:show, :create, :update, :destroy]

        resources :market_vendors, only: [:create]
        delete '/market_vendors', to: 'market_vendors#destroy'
      end
    end
  end
end
