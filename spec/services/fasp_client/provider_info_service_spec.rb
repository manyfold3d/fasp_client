describe FaspClient::ProviderInfoService, :vcr do
  context "when querying a FASP provider info endpoint", vcr: { cassette_name: "services/provider_info_service_spec/success" } do
    let(:provider) { create :provider, :registered }
    subject(:service) { described_class.new(provider: provider) }

    it "succeeds in fetching capabilities" do
      expect(service.to_provider_attributes).to include({
        capabilities: [
          { id: "account_search", version: "0.1" },
          { id: "data_sharing", version: "0.1" },
          { id: "follow_recommendation", version: "0.1" },
          { id: "trends", version: "0.1" }
        ]
      })
    end

    it "succeeds in fetching privacy policies" do
      expect(service.to_provider_attributes).to include({
        privacy_policy: [ { url: "https://example.com/privacy", language: "en" } ]
      })
    end

    it "succeeds in fetching signin URL" do
      expect(service.to_provider_attributes).to include({ sign_in_url: "http://localhost:3000/session/new" })
    end

    it "succeeds in fetching contact email" do
      expect(service.to_provider_attributes).to include({ contact_email: "test@example.com" })
    end

    it "succeeds in fetching fediverse account" do
      expect(service.to_provider_attributes).to include({ fediverse_account: "@test@example.com" })
    end

    it "verifies content digest of response"

    it "verifies signature of response"
  end
end
