Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :admin do
    resources :invoices, except: [:destroy, :create, :new]
    get "/", to: "dashboard#index"
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
  end


  resources :merchants, except: [:destroy, :index, :show, :edit, :update, :new, :create] do
    resources :items, except: [:destroy], controller: 'merchants/items'
    resources :invoices, except: [:destroy, :new, :create], controller: 'merchants/invoices'
    resources :bulk_discounts, module: :merchants, only: [:destroy, :index, :show, :edit, :update, :new, :create] 

    get "/dashboard", to: "merchants#show"
  end

end