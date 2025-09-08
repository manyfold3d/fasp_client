FaspClient::Engine.routes.draw do
  post "/registration" => "providers#create"
  resources :providers, only: [ :index, :edit, :update ]
  resources :event_subscriptions, only: [ :create, :destroy ], path: "data_sharing/v0/event_subscriptions"
end
