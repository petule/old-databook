Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'jak-vydat-elektronickou-knihu', to: 'pages#ebook_publishing', as: 'ebook_publishing'
  get 'kontakt', to: 'pages#contact', as: 'contact'
  get 'programatori-v-ruby-on-rails', to: 'pages#programming', as: 'programming'
  get 'inzerce', to: 'pages#propagation', as: 'propagation'
  get 'pridat-e-knihu', to: 'pages#add_ebook', as: 'add_ebook'
  get 'sluzby', to: 'pages#services', as: 'services'
  #mount Ckeditor::Engine => '/ckeditor'
  #devise_for :users, skip: [:password, :session, :registration]
  #devise_scope :user do
  #  get 'zapomenute-heslo', to: 'customers/passwords#new', as: 'new_customer_password'
  #  get 'zmena-hesla', to: 'customers/passwords#edit', as: 'edit_customer_password'
  #  put 'heslo', to: 'customers/passwords#update', as: 'customer_password'
  #  post 'heslo', to: 'customers/passwords#create'

  #  get 'prihlaseni', to: 'customers/sessions#new', as: 'new_customer_session'
  #  post 'prihlaseni', to: 'customers/sessions#create', as: 'customer_session'
  #  delete '', to: 'customers/sessions#destroy', as: 'destroy_customer_session'

  #  get 'registrace', to: 'customers/registrations#new', as: 'new_customer_registration'
  #  post 'registrace', to: 'customers/registrations#create', as: 'customer_registration'
  #  patch 'registrace', to: 'customers/registrations#edit', as: 'edit_customer'
  #  put 'registrace', to: 'customers/registrations#update'
  #end

  get 'ucet', to: 'customers#account', as: 'customer_account'

  get 'kosik', to: 'carts#show', as: 'show_basket'
  get 'kosik-2', to: 'carts#payment', as: 'payment_basket'
  get 'kosik-3', to:'carts#finish', as: 'finish_basket'

  get 'categories/index'
  resources :categorie, controller: "categories"

  resources :customers do
    collection do
      get :library
      get :history
      get :wishlist
      get :edit
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  get 'products/index'
  get 'products/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
