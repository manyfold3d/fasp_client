module FaspClient
  class BackfillRequest < ApplicationRecord
    belongs_to :fasp_client_provider, class_name: "FaspClient::Provider"

    validates :fasp_client_provider, presence: true
    validates :category, presence: true, inclusion: FaspClient::ApplicationRecord::CATEGORIES
    validates :max_count, presence: true
  end
end
