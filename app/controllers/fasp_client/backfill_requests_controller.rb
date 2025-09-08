module FaspClient
  class BackfillRequestsController < ApplicationController
    wrap_parameters :backfill_request, include: [ :category, :maxCount ]
    before_action :get_provider
    before_action :verify_request

    def create
      options = params.deep_transform_keys(&:underscore).expect(backfill_request: [ :category, :max_count ])
      req = FaspClient::BackfillRequest.create(options.merge(fasp_client_provider: @provider))
      if req.valid?
        respond_to do |format|
          format.json do
            render json: { "backfillRequest" => { "id" => req.id.to_s } }, status: :created
          end
        end
      else
        head :unprocessable_content
      end
    end
  end
end
