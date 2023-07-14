Rails.application.routes.draw do

  devise_for :users

  resource :cart
  root "carts#edit"

  namespace :admin do
    root 'dashboard#dashboard'
    resources :products
    resources :users
    resources :schools
    resources :customers

    post '/orders/batch' => 'orders#batch'
    post '/orders/export/prepare' => 'orders#export_prepare'
    post '/orders/export/finish' => 'orders#export_finish'
    get '/orders/export//:weight_type/:export_type' => 'orders#export', as: :orders_export_type
    resources :orders

    put '/orders/:id/deactivate' => 'orders#deactivate', as: :deactivate_order
    put '/orders/:id/activate' => 'orders#activate', as: :activate_order

    put '/customers/:id/deactivate' => 'customers#deactivate', as: :deactivate_customer
    put '/customers/:id/activate' => 'customers#activate', as: :activate_customer
  end
  get '/admin', to: redirect('/admin')

  get '/checkout' => 'orders#new', as: :checkout
  post '/checkout' => 'orders#validate', as: :validate
  post '/checkout/save' => 'orders#checkout_save', as: :checkout_save

  post '/orders' => 'orders#create', as: :orders

  get '/confirm' => 'orders#confirm', as: :confim_order

  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'

  get 'pages/*page', to: 'pages#show'

end
