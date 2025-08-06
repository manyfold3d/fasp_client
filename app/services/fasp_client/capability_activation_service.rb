module FaspClient
  class CapabilityActivationService
    def initialize(provider:, capability:, version:)
      @provider = provider
      @capability = capability
      @major_version = version.split(".").first
    end

    def enable!
      HttpRequestService.new(provider: @provider).execute!(
        Net::HTTP::Post.new(uri)
      ).code == "204"
    end

    def disable!
      HttpRequestService.new(provider: @provider).execute!(
        Net::HTTP::Delete.new(uri)
      ).code == "204"
    end

    private

    def uri
      URI("#{@provider.base_url}/capabilities/#{@capability}/#{@major_version}/activation")
    end
  end
end
