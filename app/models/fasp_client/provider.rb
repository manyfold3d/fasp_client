module FaspClient
  class Provider < ApplicationRecord
    validates :name, presence: true
    validates :base_url, presence: true
    validates :server_id, presence: true
    validates :public_key, presence: true
  end
end
