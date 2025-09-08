module FaspClient
  class EventSubscriptionsController < ApplicationController
    wrap_parameters :event_subscription, include: [ :category, :subscriptionType ]
    before_action :get_provider
    before_action :verify_request

    def create
      options = params.deep_transform_keys(&:underscore).expect(event_subscription: [ :category, :subscription_type ])
      if options[:category] == "content" && options[:subscription_type] == "trends"
        head :not_implemented
        return
      end
      sub = FaspClient::EventSubscription.create(options.merge(fasp_client_provider: @provider))
      if sub.valid?
        respond_to do |format|
          format.json do
            render json: { "subscription" => { "id" => sub.id.to_s } }, status: :created
          end
        end
      else
        head :unprocessable_content
      end
    end

    def destroy
      @subscription = @provider.fasp_client_event_subscriptions.find(params[:id])
      @subscription.destroy
      head :no_content
    end
  end
end
