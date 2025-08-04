describe FaspClient::Provider do
  let(:good_attributes) do
    {
      name: "Example FASP",
      base_url: "https://fasp.example.com",
      server_id: "b2ks6vm8p23w",
      public_key: "FbUJDVCftINc9FlgRu2jLagCVvOa7I2Myw8aidvkong="
    }
  end

  it "is valid if created with good attributes" do
    expect(described_class.new(good_attributes)).to be_valid
  end

  context "with a valid object" do
    subject(:provider) { described_class.create(good_attributes) }

    it "should decode a valid verify key for the remote server" do
      expect(provider.verify_key).to be_a(Ed25519::VerifyKey)
    end
  end
end
