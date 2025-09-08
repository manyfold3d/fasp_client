module FaspClient
  class EventSubscription < ApplicationRecord
    belongs_to :fasp_client_provider, class_name: "FaspClient::Provider"

    validates :fasp_client_provider, presence: true
    validates :category, presence: true, inclusion: FaspClient::ApplicationRecord::CATEGORIES
    validates :subscription_type, presence: true, inclusion: [ "lifecycle", "trends" ], if: -> { category == "content" }
    validates :subscription_type, presence: true, inclusion: [ "lifecycle" ], unless: -> { category == "content" }
  end
end
