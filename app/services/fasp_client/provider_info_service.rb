require "linzer"
require "byebug"

module FaspClient
  class ProviderInfoService
    def initialize(provider:)
      @provider = provider
    end

    def to_provider_attributes
      response = HttpRequestService.new(provider: @provider).execute!(
        Net::HTTP::Get.new(URI(@provider.base_url + "/provider_info"))
      )
      json ||= JSON.parse(response.body)
      json.slice(
        "capabilities",
        "privacyPolicy",
        "signInUrl",
        "contactEmail",
        "fediverseAccount"
      ).deep_transform_keys(&:underscore).deep_symbolize_keys
    end
  end
end
