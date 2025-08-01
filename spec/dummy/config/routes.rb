Rails.application.routes.draw do
  mount FaspClient::Engine => "/fasp"
end
