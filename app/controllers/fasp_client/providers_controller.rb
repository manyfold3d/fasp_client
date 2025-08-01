module FaspClient
  class ProvidersController < ApplicationController
    def create
      params.expect(:name, :baseUrl, :serverId, :publicKey)
      head :created
    end
  end
end
