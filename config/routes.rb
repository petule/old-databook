Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'discounts', to: 'pages#discounts', as: 'discounts'
  get 'newsweek', to: 'pages#newsweek', as: 'newsweek'
  get 'presents', to: 'pages#presents', as: 'presents'
  get 'ebooks', to: 'pages#ebooks', as: 'ebooks'

  get 'jak-vydat-elektronickou-knihu', to: 'pages#ebook_publishing', as: 'ebook_publishing'
  get 'kontakt', to: 'pages#contact', as: 'contact'
  get 'programatori-v-ruby-on-rails', to: 'pages#programming', as: 'programming'
  get 'inzerce', to: 'pages#propagation', as: 'propagation'
  get 'pridat-e-knihu', to: 'pages#add_ebook', as: 'add_ebook'
  get 'sluzby', to: 'pages#services', as: 'services'
  get 'kdo-jsme', to: 'pages#about_us', as: 'about_us'

  get 'napoveda', to: 'pages#helps', as: 'helps'
  get 'jak-stahovat-eknihy', to: 'pages#download_books', as: 'download_books'
  get 'podrobne_hledani', to: 'pages#searching', as: 'searching'
  get 'jak-cist-eknihy', to: 'pages#how_read', as: 'how_read'
  get 'kde-je-ma-objednavka', to: 'pages#where_order', as: 'where_order'
  get 'kde-je-moje-ekniha', to: 'pages#where_is_ebook', as: 'where_is_ebook'
  get 'jak-funguje-knihovnicka', to: 'pages#about_bookcase', as: 'about_bookcase'
  get 'reklamace-eknih', to: 'pages#complaint', as: 'complaint'
  get 'zpusoby-platby', to: 'pages#payment_methods', as: 'payment_methods'
  get 'ochrana-osobnich-udaju', to: 'pages#personal_data_protection', as: 'personal_data_protection'
  get 'obchodni-podminky', to: 'pages#terms_and_conditions', as: 'terms_and_conditions'
  get 'newsletter', to: 'pages#newsletter'
  get 'vyhody-registrace', to: 'pages#about_registration', as: 'about_registration'
  get 'isbn', to: 'pages#isbn'
  get 'kolik-vydelate-prodejem-e-knih', to: 'pages#commission', as: 'commission'
  get 'cena-vydani-elektronicke-knihy', to: 'pages#price', as: 'price'
  get 'vydani-knihy-vlastnim-nakladem', to: 'pages#selfpublishing', as: 'selfpublishing'
  get 'podklady-pro-vyrobu-elektronicke-knihy', to: 'pages#data', as: 'data'
  get 'vyroba-elektronicke-knihy', to: 'pages#creation_book', as: 'creation_book'
  get 'vydani-tistene-knihy', to: 'pages#printbook', as: 'printbook'
  get 'darkove-poukazy', to: 'pages#vouchers', as: 'vouchers'
  get 'prodejci-elektronickych-knih', to: 'pages#distributors', as: 'distributors'
  get 'jak-uspesne-prodavat-knihu', to: 'pages#success', as: 'success'
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
  get 'categories/show'
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
