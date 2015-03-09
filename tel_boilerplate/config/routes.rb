require 'sidekiq/web'

ProjectName::Application.routes.draw do
  
  # ------- App -------

  root controller: "pages", action: "home"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: "users/passwords"
  }
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticate :user, ->(user) { user.role? :admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  # ------- API -------
  
  

  # ------- Pulse -------
  
  get "/pulse" => "pulse#pulse"

  # ------- 404s -------

  match "*any", to: "application#routing_error", via: :all
  
end