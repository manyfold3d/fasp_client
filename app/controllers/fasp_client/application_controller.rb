module FaspClient
  class ApplicationController < FaspClient::Configuration.instance.controller_base.constantize
    layout FaspClient::Configuration.instance.layout

    after_action :sign_response

    def fasp_client_controller?
      true
    end

    def get_provider
      head :unauthorized and return unless request.headers.key?("Signature-Input")
      m = request.headers["Signature-Input"].match(/keyid=\"([^\"]+)\"/)
      @provider = FaspClient::Provider.find_by(uuid: m[1]) if m
      head :unauthorized if @provider.nil?
    end

    def verify_request
      head :unauthorized unless @provider.valid_request?(request)
    end

    private

    def authenticate
      head :forbidden unless FaspClient::Configuration.instance.authenticate.call(request)
    end

    def sign_response
      if @provider
        response["date"] = Time.now.utc.to_s
        response["content-digest"] = "sha-256=:"+Digest::SHA256.base64digest(response.body || "")+":"
        Linzer.sign!(
          response,
          key: @provider.local_linzer_key,
          components: %w[@status content-digest],
          label: "sig1",
          params: {
            created: Time.now.utc.to_i
          }
        )
      end
    end
  end
end
