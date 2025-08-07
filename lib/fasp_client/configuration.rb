module FaspClient
  class Configuration
    include Singleton

    attr_accessor :authenticate

    def initialize
      @authenticate = ->(request) { }
    end
  end
end
