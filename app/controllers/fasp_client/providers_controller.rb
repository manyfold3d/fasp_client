module FaspClient
  class ProvidersController < ApplicationController
    wrap_parameters :provider, include: [ :name, :baseUrl, :serverId, :publicKey ]

    def create
      attributes = params.deep_transform_keys(&:underscore).expect(provider: [ :name, :base_url, :server_id, :public_key ])
      p = Provider.create(attributes)
      head p.valid? ? :created : :bad_request
    end
  end
end
