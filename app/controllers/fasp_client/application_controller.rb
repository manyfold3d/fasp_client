module FaspClient
  class ApplicationController < ActionController::Base
    layout FaspClient::Configuration.instance.layout

    private

    def authenticate
      head :forbidden unless FaspClient::Configuration.instance.authenticate.call(request)
    end
  end
end
