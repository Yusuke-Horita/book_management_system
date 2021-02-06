Rails.application.routes.draw do
  namespace :admins do
    get 'check_outs/index'
    get 'check_outs/show'
    get 'check_outs/edit'
  end
  get 'check_outs/index'
  get 'check_outs/show'
  get 'check_outs/edit'
  devise_for :users
  devise_for :admins

  root 'users/homes#top'

  scope module: :users do
    get 'check_outs/return_page' => 'check_outs#return_page'
    resources :cart_items, only: [:create, :destroy]
    resources :check_outs, only: [:index, :new, :create, :show, :destroy]
  end

  namespace :admins do
    resources :books, only: [:index, :new, :create, :show, :edit, :update, :destroy]
    resources :check_outs, only: [:index, :show, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
