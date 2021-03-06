Babysworld::Application.routes.draw do
  root :to => "products#index"
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, :skip => [:sessions], controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  match 'signout', to: 'sessions#destroy', as: 'signout'

  get '/about', to: 'welcome#about'
  get '/terms', to: 'welcome#terms'
  get '/user_consignment', to: 'welcome#user_consignment'
  get '/consignment_about', to: 'welcome#consignment_about'
  get '/faq', to: 'welcome#faq'
  get '/robots.txt', to: 'welcome#robots'

  get 'tags/:tag', to: 'products#index', as: :tag

  namespace :admin do
    resources :products do
      put '/release', to: 'products#release'
      put '/waiting_for_money', to: 'products#waiting_for_money'
      put '/sold', to: 'products#sold'
    end
    resources :banners
    resources :consignments
    resources :consignment_products do
      put '/deny', to: 'consignment_products#deny'
      resources :products, controller: 'consignment_products/products'
    end
    resources :billings
  end

  resources :users, only: [:edit, :update] do
    resources :billings, only: [:create, :index]
  end

  resources :billings do
    resources :consignment_products, only: [:index]
  end

  resources :products, :only => [:index, :show]

  resources :consignments
  resources :consignment_products do
    put '/billing', to: 'consignment_products#billing'
  end

end
