module FaspClient
  class ApplicationController < ActionController::Base
    private

    def authenticate
      head :forbidden unless FaspClient::Configuration.instance.authenticate.call(request)
    end
  end
end
