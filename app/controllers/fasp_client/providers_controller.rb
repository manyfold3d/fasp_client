module FaspClient
  class ProvidersController < ApplicationController
    wrap_parameters :provider, include: [ :name, :baseUrl, :serverId, :publicKey ]

    def create
      attributes = params.deep_transform_keys(&:underscore).expect(provider: [ :name, :base_url, :server_id, :public_key ])
      p = Provider.create(attributes)
      if p.valid?
        render json: {
          faspId: p.uuid,
          publicKey: Base64.strict_encode64(p.ed25519_signing_key.verify_key.to_bytes),
          registrationCompletionUri: providers_url
        }, status: :created
      else
        head :bad_request
      end
    end
  end
end
