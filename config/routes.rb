FaspClient::Engine.routes.draw do
  post "/registration" => "providers#create"
  resources :providers, only: [ :index, :update ]
end
