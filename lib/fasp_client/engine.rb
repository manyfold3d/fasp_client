require "linzer"

module FaspClient
  class Engine < ::Rails::Engine
    isolate_namespace FaspClient

    config.to_prepare do
      # Include main application helpers so we can allow it to override views
      FaspClient::ApplicationController.helper Rails.application.helpers
    end
  end
end
