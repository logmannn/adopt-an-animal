Rails.application.routes.draw do
  devise_for :users
  root :to => 'products#index'

  resource :cart, only: [:show]

  resources :news, only: [:index]

  resources :products

  resources :shirts

  resources :charges

  resources :accounts

  resources :order_items do
    resources :orders
  end



end
