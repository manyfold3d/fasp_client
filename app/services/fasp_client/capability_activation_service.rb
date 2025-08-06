require "linzer"
require "byebug"

module FaspClient
  class CapabilityActivationService
    def initialize(provider:, capability:, version:)
      @provider = provider
      @capability = capability
      @major_version = version.split(".").first
    end

    def enable!
      http_request(Net::HTTP::Post.new(uri)).code == "204"
    end

    def disable!
      http_request(Net::HTTP::Delete.new(uri)).code == "204"
    end

    private

    def uri
      URI("#{@provider.base_url}/capabilities/#{@capability}/#{@major_version}/activation")
    end

    def http_request(request)
      request["date"] = Time.now.utc.to_s
      request["Content-Digest"] = "sha-256=:"+Digest::SHA256.base64digest("")+":" # No content, but we need a digest anyway!
      Linzer.sign!(
        request,
        key: linzer_key,
        components: %w[@method @target-uri content-digest],
        label: "sig1",
        params: {
          created: Time.now.utc.to_i
        }
      )
      response = nil
      Net::HTTP.start uri.hostname, uri.port do |http|
        response = http.request request
      end
      response
    end

    def private_pem
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

    def linzer_key
      Linzer.new_ed25519_key(private_pem, @provider.server_id)
    end
  end
end
