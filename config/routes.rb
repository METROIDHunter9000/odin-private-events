Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
  get 'home', to: "home#index"
  get 'index', to: "home#index"


  # IMPORTANT NOTE: order of operations:
  # When an HTTP request is received, the server attempts to route the request
  # by matching the request path against the routes
  # but it does this in TOP-DOWN order
  # Devise adds many GET paths of the form "/user/action"
  # If you have the "show" action set up for your user (which you probably do)
  # then devise will conflict with your show path "/user/:id", 
  # e.g. by routing a GET to "/user/sign_in" to the handler for "/user/:id" rather than "/user/sign_in"
  # which creates funny errors trying to find a user with id "sign_in"
  # SOLUTION: declare your devise routes before you declare the routes for the user itself
  # NEVER MIND: that breaks user registration, as now 
  # "POST /users" gets handled by Devise::RegistrationsController#create instead of UsersController#create
  # SOLUTION: configure the "User" resource's "show" action (which will go to UsersController#show)
  # to use a different path which will not conflict with the paths devise sets up (e.g. /users/sign_in)
  # resources :events
  # resources :users, only: [:new, :create]
  # get '/users/:id/events', to: "users#show", as: "user"

  resources :users, only: [:show, :new, :create], param: :username do
    # create /users/:user_username/events path only for the events#index action
    resources :events, only: :index
  end

  # create /events path for all actions
  resources :events do
    # add routes for the Rsvps join table
    resources :rsvps, only: :index, to: "rsvps#index"
    post '/rsvp/:user_id', to: "rsvps#create", as: "rsvp"
    delete '/rsvp/:user_id', to: "rsvps#destroy"

    resources :invitations, only: :index, to: "event_invitations#index", as: "invitations"
    post '/invitation/:user_id', to: "event_invitations#create", as: "invitation"
    delete '/invitation/:user_id', to: "event_invitations#destroy"

    resources :requests, only: :index, to: "event_requests#index", as: "requests"
    post '/request/:user_id', to: "event_requests#create", as: "request"
    delete '/request/:user_id', to: "event_requests#destroy"
  end


  # activate devise routes for the User model
  devise_for :users, path: 'accounts'
end
