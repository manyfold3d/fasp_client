module FaspClient
  class Provider < ApplicationRecord
    validates :uuid, presence: true
    validates :name, presence: true
    validates :base_url, presence: true
    validates :server_id, presence: true
    validates :public_key, presence: true

    before_create do
      self.uuid = SecureRandom.uuid
    end
  end
end
