Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :pdf, only: :create, controller: :pdf do
    member do
      get :signature
      get :download
    end
  end


  post 'mifiel', controller: :hooks, action: :mifiel
end
