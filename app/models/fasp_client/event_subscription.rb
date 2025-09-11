module FaspClient
  class EventSubscription < ApplicationRecord
    belongs_to :fasp_client_provider, class_name: "FaspClient::Provider"

    validates :fasp_client_provider, presence: true
    validates :category, presence: true, inclusion: FaspClient::ApplicationRecord::CATEGORIES
    validates :subscription_type, presence: true, inclusion: [ "lifecycle", "trends" ], if: -> { category == "content" }
    validates :subscription_type, presence: true, inclusion: [ "lifecycle" ], unless: -> { category == "content" }

    def announce_lifecycle(event_type:, uri:)
      return if subscription_type != "lifecycle"
      Rails.logger.debug("Announcing #{subscription_type} event: #{event_type} #{category} #{uri}")
      request = Net::HTTP::Post.new(URI(fasp_client_provider.base_url + "/data_sharing/v0/announcements"))
      request.body = {
        source: {
          subscription: {
            id: id.to_s
          }
        },
        category: category,
        eventType: event_type,
        objectUris: [ uri ]
      }.to_json
      request.content_type = "application/json"
      HttpRequestService.new(provider: fasp_client_provider).execute!(request)
    end
  end
end
