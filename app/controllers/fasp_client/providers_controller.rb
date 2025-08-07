module FaspClient
  class ProvidersController < ApplicationController
    wrap_parameters :provider, include: [ :name, :baseUrl, :serverId, :publicKey ]
    protect_from_forgery with: :null_session, only: :create
    before_action :authenticate, except: [ :create ]
    before_action :get_provider, except: [ :create, :index ]

    def create
      attributes = params.deep_transform_keys(&:underscore).expect(provider: [ :name, :base_url, :server_id, :public_key ])
      p = Provider.create(attributes)
      if p.valid?
        render json: {
          faspId: p.uuid,
          publicKey: Base64.strict_encode64(p.ed25519_signing_key.verify_key.to_bytes),
          registrationCompletionUri: edit_provider_url(p)
        }, status: :created
      else
        head :bad_request
      end
    end

    def index
      @providers = Provider.all
    end

    def update
      provider_params = params.expect(provider: [ :status, enable_capability: [ :id, :version ], disable_capability: [ :id, :version ] ])
      head :bad_request and return unless provider_params
      if provider_params[:enable_capability]
        success = @provider.enable(provider_params[:enable_capability][:id], provider_params[:enable_capability][:version])
        redirect_back_or_to edit_provider_path(@provider), notice: success ? "Enabled" : "Failed"
      elsif provider_params[:disable_capability]
        success = @provider.disable(provider_params[:disable_capability][:id], provider_params[:disable_capability][:version])
        redirect_back_or_to edit_provider_path(@provider), notice: success ? "Disabled" : "Failed"
      elsif @provider.update!(provider_params)
        redirect_back_or_to edit_provider_path(@provider)
      else
        head :bad_request
      end
    end

    def get_provider
      @provider = Provider.find_by(id: params[:id])
    end
  end
end
