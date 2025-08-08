module FaspClient
  class Configuration
    include Singleton

    attr_accessor :authenticate
    attr_accessor :layout
    attr_accessor :controller_base

    def initialize
      @authenticate = ->(request) { }
      @layout = "application"
      @controller_base = "ActionController::Base"
    end
  end
end
