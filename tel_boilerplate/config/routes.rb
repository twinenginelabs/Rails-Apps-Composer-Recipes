require 'sidekiq/web'

ProjectName::Application.routes.draw do
  
  # ------- App -------

  root controller: "pages", action: "home"

  devise_for :users, :controllers => { registrations: "v1/registrations", sessions: "v1/sessions" }
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticate :user, ->(user) { user.role? :admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  # ------- API -------
  
  api_version(module: "V1", path: { value: "v1" }, default: true) do

  end

  # ------- Pulse -------
  
  get "/pulse" => "pulse#pulse"

  # ------- 404s -------

  match "*any", to: "application#routing_error", via: :all
  
end