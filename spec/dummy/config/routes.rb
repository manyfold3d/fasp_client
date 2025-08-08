Rails.application.routes.draw do
  root to: "home#index"
  mount FaspClient::Engine => "/fasp"
end
