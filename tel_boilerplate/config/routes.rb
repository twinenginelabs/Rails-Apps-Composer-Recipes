require 'sidekiq/web'

ProjectName::Application.routes.draw do
  
  # ------- App -------

  root :controller => "pages", :action => "home"

  devise_for :users, :controllers => { :registrations => "v1/registrations", :sessions => "v1/sessions" }
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  authenticate :user, ->(user) { user.role? :admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/404', :to => "exceptions#render_status"
  get '/422', :to => "exceptions#render_status"
  get '/500', :to => "exceptions#render_status"

  # ------- Pulse -------
  
  get "/pulse" => "pulse#pulse"
  
  # ------- API -------
  
  api_version(module: "V1", path: { value: "v1" }, default: true) do

  end

  # ------- API Documentation -------

  apipie
  
end