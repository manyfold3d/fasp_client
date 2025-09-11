require "linzer"

module FaspClient
  class Engine < ::Rails::Engine
    isolate_namespace FaspClient

    config.to_prepare do
      # Include main application helpers so we can allow it to override views
      FaspClient::ApplicationController.helper Rails.application.helpers

      Linzer::Message.register_adapter(ActionDispatch::Request, Linzer::Message::Adapter::Rack::Request)
    end
  end
end
