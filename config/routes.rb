Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'record#index'
  get '/signup', to: 'user#new'
  post '/login', to: 'application#login_action'
  post '/logout', to: 'application#logout'

  resources :record
  resources :user
end
