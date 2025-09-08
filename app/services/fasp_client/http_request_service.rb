require "linzer"

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
        key: local_key,
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

    def verified?(request)
      # Not implemented yet
      true
    end

    private

    def local_pem
      asn1 = OpenSSL::ASN1.Sequence(
        [
          OpenSSL::ASN1::Integer(OpenSSL::BN.new(0)),
          OpenSSL::ASN1.Sequence(
            [
              OpenSSL::ASN1.ObjectId("ED25519")
            ]
          ),
          OpenSSL::ASN1.OctetString(OpenSSL::ASN1.OctetString(@provider.ed25519_signing_key.to_bytes).to_der)
        ]
      )
      <<~PEM
        -----BEGIN PRIVATE KEY-----
        #{Base64.strict_encode64(asn1.to_der)}
        -----END PRIVATE KEY-----
      PEM
    end

    def local_key
      Linzer.new_ed25519_key(local_pem, @provider.server_id)
    end
  end
end
