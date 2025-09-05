require "linzer"

module FaspClient
  class FollowRecommendationService
    def initialize(provider:)
      @provider = provider
    end

    def for(account_uri:)
      response = HttpRequestService.new(provider: @provider).execute!(
        Net::HTTP::Get.new(URI(@provider.base_url + "/follow_recommendation/v0/accounts?accountUri=" + CGI.escape(account_uri)))
      )
      JSON.parse(response.body)
    end
  end
end
