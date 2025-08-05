require "ed25519"
require "fasp_client/ed25519_signing_key_coder"

module FaspClient
  class Provider < ApplicationRecord
    enum :status, { pending: nil, approved: 1, denied: -1 }, default: :pending, validate: true

    validates :uuid, presence: true
    validates :name, presence: true
    validates :base_url, presence: true
    validates :server_id, presence: true
    validates :public_key, presence: true
    validates :ed25519_signing_key, presence: true

    serialize :ed25519_signing_key, coder: FaspClient::Ed25519SigningKeyCoder

    before_validation on: :create do
      self.uuid = SecureRandom.uuid
      self.ed25519_signing_key = Ed25519::SigningKey.generate
    end

    def verify_key
      Ed25519::VerifyKey.new(Base64.strict_decode64(public_key))
    end

    def fingerprint
      Digest::SHA256.base64digest(verify_key)
    end
  end
end
