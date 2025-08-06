describe FaspClient::Provider do
  it "is valid if created with good attributes" do
    expect(described_class.new(attributes_for :provider)).to be_valid
  end

  context "with a valid object", vcr: { cassette_name: "services/provider_info_service_spec/success" } do
    subject(:provider) { create :provider, :registered }

    it "should decode a valid verify key for the remote server" do
      expect(provider.verify_key).to be_a(Ed25519::VerifyKey)
    end

    it "should generate a key fingerprint for the remote server" do
      expect(provider.fingerprint).to eq "UfiY2qzXEwLzCcFMaW8a2AFyiWlSspnyf4DmqXoKquY="
    end

    it "has pending status by default" do
      expect(provider).to be_pending
    end

    it "can be approved" do
      provider.approved!
      expect(provider).to be_approved
    end

    it "can be approved via update" do
      provider.update!(status: "approved")
      expect(provider).to be_approved
    end

    it "can be denied" do
      provider.denied!
      expect(provider).to be_denied
    end

    it "can be denied via update" do
      provider.update!(status: "denied")
      expect(provider).to be_denied
    end

    it "has empty capabilities by default" do
      expect(provider.capabilities).to eq []
    end

    it "stores capabilities via update" do
      provider.update!(capabilities: [
        { id: "trends", version: "1.0" },
        { id: "account_search", version: "1.0" }
      ])
      expect(provider.capabilities).not_to be_empty
    end

    it "serialises and deserialises capabilities properly" do
      provider.update!(capabilities: [
        { id: "trends", version: "1.0" },
        { id: "account_search", version: "1.0" }
      ])
      expect(provider.reload.capabilities).not_to be_empty
    end

    it "automatically fetches provider capabilities when approved" do
      expect { provider.approved! }.to change { provider.has_capability? :account_search }.from(false).to(true)
    end

    it "automatically fetches privacy policy when approved" do
      provider.approved!
      expect(provider.privacy_policy).not_to be_empty
    end

    it "automatically fetches fediverse account when approved" do
      provider.approved!
      expect(provider.fediverse_account).to eq "@test@example.com"
    end

    it "automatically fetches contact email when approved" do
      provider.approved!
      expect(provider.contact_email).to eq "test@example.com"
    end

    it "automatically fetches signin URL when approved" do
      provider.approved!
      expect(provider.sign_in_url).to eq "http://localhost:3000/session/new"
    end
  end

  context "with known capabilities" do
    subject(:provider) { create :provider,
      capabilities: [
        { id: "trends", version: "1.0" },
        { id: "trends", version: "1.1" },
        { id: "account_search", version: "1.0" }
      ]
    }

    it "has an array of capabilities" do
      expect(provider.capabilities.first).to eq({ "id" => "trends", "version" => "1.0" })
    end

    it "can be queried by capability id" do
      expect(provider.has_capability? :trends).to be true
    end

    it "does not support unknown capabilities" do
      expect(provider.has_capability? :debug).to be false
    end

    it "can be queried by capability id and version" do
      expect(provider.has_capability? :trends, "1.0").to be true
    end

    it "does not support known capabilities with unknown versions" do
      expect(provider.has_capability? :trends, "0.1").to be false
    end

    it "can list versions for capability" do
      expect(provider.capability_versions :trends).to eq [ "1.0", "1.1" ]
    end

    it "gets no versions for unknown capabilities" do
      expect(provider.capability_versions :debug).to eq []
    end

    it "lists available capability IDs" do
      expect(provider.capability_ids).to eq [ :trends, :account_search ]
    end
  end
end
