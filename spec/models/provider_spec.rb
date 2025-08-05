describe FaspClient::Provider do
  let(:good_attributes) do
    {
      name: "Example FASP",
      base_url: "https://fasp.example.com",
      server_id: "b2ks6vm8p23w",
      public_key: "pDnfhQyTX06RNDhyDI7yMlSohxcpOzHF/xUbJ5DTgAA="
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

    it "should generate a key fingerprint for the remote server" do
      expect(provider.fingerprint).to eq "i3ZYehBFp2THB39mcU1xJH459YzOcrrvgO8Lpd83haI="
    end

    it "has pending status by default" do
      expect(provider).to be_pending
    end

    it "can be approved" do
      provider.approved!
      expect(provider).to be_approved
    end

    it "can be denied" do
      provider.denied!
      expect(provider).to be_denied
    end

  end
end
