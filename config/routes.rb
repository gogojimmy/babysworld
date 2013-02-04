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

  get 'tags/:tag', to: 'products#index', as: :tag

  namespace :admin do
    resources :products
    resources :banners
    resources :consignments
    resources :billings
  end

  resources :users, only: [:edit, :update] do
    resources :billings, only: [:create, :index]
  end

  resources :products, :only => [:index, :show]

  resources :consignments

end
