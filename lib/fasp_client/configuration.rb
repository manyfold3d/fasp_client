module FaspClient
  class Configuration
    include Singleton

    attr_accessor :authenticate
    attr_accessor :layout

    def initialize
      @authenticate = ->(request) { }
      @layout = "application"
    end
  end
end
