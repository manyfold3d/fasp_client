module FaspClient
  class ApplicationController < FaspClient::Configuration.instance.controller_base.constantize
    layout FaspClient::Configuration.instance.layout

    def fasp_client_controller?
      true
    end

    private

    def authenticate
      head :forbidden unless FaspClient::Configuration.instance.authenticate.call(request)
    end
  end
end
