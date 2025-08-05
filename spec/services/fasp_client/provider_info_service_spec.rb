describe FaspClient::ProviderInfoService, :vcr do
  context "when querying a FASP provider info endpoint", vcr: { cassette_name: "services/provider_info_service_spec/success" } do
    let(:provider) {
      # This setup is from a manually-registered local fediscoverer instance;
      # if you need to change the cassettes to run against a real instance,
      # you'll need different values here.
      FaspClient::Provider.create(
        name: "fediscoverer",
        base_url: "http://localhost:3000/fasp",
        server_id: "7",
        public_key: "2m4yAcnNSi5qX5JgyX8MnuKjf/7W87qdqT6t6y/IJc0=",
        uuid: "ae95fe4f-c52e-408e-8212-c827126e5f7e",
        ed25519_signing_key: Ed25519::SigningKey.new(Base64.strict_decode64("hqRBxE0Eaby1lVevr3SBNglxLXmAOLSJQQFE5S4Lf7Q=")),
      )
    }
    subject(:service) { described_class.new(provider: provider) }

    it "succeeds in fetching data" do
      expect(service.send(:get).code).to eq "200"
    end

    it "succeeds in fetching data" do
      expect(service.to_provider_attributes).to include({
        capabilities: [
          { id: "account_search", version: "0.1" },
          { id: "data_sharing", version: "0.1" },
          { id: "follow_recommendation", version: "0.1" },
          { id: "trends", version: "0.1" }
        ]
      })
    end

    it "can automatically update the provider" do
      service.update_provider!
      expect(provider.has_capability? :trends, "0.1").to be true
    end

    it "verifies content digest of response"

    it "verifies signature of response"
  end
end
