describe FaspClient::ProviderInfoService, :vcr do
  context "when querying a FASP provider info endpoint", vcr: { cassette_name: "services/provider_info_service_spec/success" } do
    let(:provider) { create :provider, :registered }
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

    it "verifies content digest of response"

    it "verifies signature of response"
  end
end
