FaspClient::Engine.routes.draw do
  post "/registration" => "providers#create"
end
