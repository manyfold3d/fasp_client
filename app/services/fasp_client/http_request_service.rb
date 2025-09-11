module FaspClient
  class HttpRequestService
    def initialize(provider:)
      @provider = provider
    end

    def execute!(request)
      request["date"] = Time.now.utc.to_s
      request["Content-Digest"] = "sha-256=:"+Digest::SHA256.base64digest(request.body || "")+":"
      Linzer.sign!(
        request,
        key: @provider.local_linzer_key,
        components: %w[@method @target-uri content-digest],
        label: "sig1",
        params: {
          created: Time.now.utc.to_i
        }
      )
      response = nil
      Net::HTTP.start request.uri.hostname, request.uri.port, use_ssl: (request.uri.scheme == "https") do |http|
        response = http.request request
      end
      response
    end

    def verified?(request_or_response)
      Linzer.verify!(request_or_response, key: @provider.fasp_linzer_key)
    rescue Linzer::Error
      false
    end
  end
end
