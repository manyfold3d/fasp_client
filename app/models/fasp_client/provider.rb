require "ed25519"
require "fasp_client/ed25519_signing_key_coder"

module FaspClient
  class Provider < ApplicationRecord
    enum :status, { pending: nil, approved: 1, denied: -1 }, default: :pending, validate: true

    has_many :fasp_client_event_subscriptions, class_name: "FaspClient::EventSubscription", foreign_key: "fasp_client_provider_id"

    validates :uuid, presence: true
    validates :name, presence: true
    validates :base_url, presence: true
    validates :server_id, presence: true
    validates :public_key, presence: true
    validates :ed25519_signing_key, presence: true

    serialize :ed25519_signing_key, coder: FaspClient::Ed25519SigningKeyCoder

    attribute :capabilities, :json, default: []
    attribute :privacy_policy, :json, default: []

    before_validation on: :create do
      self.uuid ||= SecureRandom.uuid
      self.ed25519_signing_key ||= Ed25519::SigningKey.generate
    end

    before_save :fetch_provider_info, if: -> { approved? && status_changed? }

    def verify_key
      Ed25519::VerifyKey.new(Base64.strict_decode64(public_key))
    end

    def fingerprint
      Digest::SHA256.base64digest(verify_key)
    end

    def has_capability?(capability, version = nil)
      version ? capability_versions(capability).include?(version) : capability_versions(capability).any?
    end

    def capability_versions(capability)
      capabilities.filter_map { |it| it["version"] if it["id"] == capability.to_s }
    end

    def capability_ids
      capabilities.map { |it| it["id"] }.uniq.map(&:to_sym)
    end

    def fetch_provider_info
      assign_attributes(ProviderInfoService.new(provider: self).to_provider_attributes) if approved?
    end

    def enable(capability, version)
      return unless has_capability?(capability, version)
      CapabilityActivationService.new(provider: self, capability: capability, version: version).enable!
    end

    def disable(capability, version)
      return unless has_capability?(capability, version)
      CapabilityActivationService.new(provider: self, capability: capability, version: version).disable!
    end

    def follow_recommendation(account_uri)
      FollowRecommendationService.new(provider: self).for(account_uri: account_uri)
    end

    def account_search(query, limit: 20)
      AccountSearchService.new(provider: self).search(query: query, limit: limit)
    end

    def valid_request?(request)
      HttpRequestService.new(provider: self).verified?(request)
    end
  end
end
