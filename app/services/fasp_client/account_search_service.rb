require "linzer"

module FaspClient
  class AccountSearchService
    def initialize(provider:)
      @provider = provider
    end

    def search(query:, limit: 20)
      response = HttpRequestService.new(provider: @provider).execute!(
        Net::HTTP::Get.new(URI(@provider.base_url + "/account_search/v0/search?limit=#{limit}&term=" + CGI.escape(query)))
      )
      JSON.parse(response.body)
    end
  end
end
