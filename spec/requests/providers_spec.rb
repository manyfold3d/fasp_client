require "rails_helper"

# registration POST   /registration(.:format)              registrations#create

RSpec.describe "Providers", type: :request do
  describe "POST /registration" do
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:params) do
      {
        "name" => "Example FASP",
        "baseUrl" => "https://fasp.example.com",
        "serverId" => "b2ks6vm8p23w",
        "publicKey" => "FbUJDVCftINc9FlgRu2jLagCVvOa7I2Myw8aidvkong="
      }
    end
    let(:request) { post "/fasp/registration", params: params, headers: headers, as: :json }

    it "succeeds" do
      request
      expect(response).to have_http_status :created
    end

    it "creates a new provider record" do
      expect { request }.to change(FaspClient::Provider, :count).by(1)
    end

    [
      "name",
      "baseUrl",
      "serverId",
      "publicKey"
    ].each do |key|
      it "returns bad request if missing #{key} parameter" do
        post "/fasp/registration", params: params.except(key), headers: headers, as: :json
        expect(response).to have_http_status :bad_request
      end
    end

    context "when request succeeds" do
      before { request }

      it "responds with JSON" do
        expect response.headers["Content-Type"] == "application/json"
      end

      it "responds with a generated ID for the provider" do
        expect(response.parsed_body["faspId"]).to be_a_uuid
      end

      it "responds with the verify key for the local server" do
        expect(
          Ed25519::VerifyKey.new(Base64.strict_decode64(response.parsed_body["publicKey"])).inspect
        ).to eq FaspClient::Provider.last.ed25519_signing_key.verify_key.inspect
      end

      it "responds with a completion URI" do
        expect(response.parsed_body["registrationCompletionUri"]).to eq "http://www.example.com/fasp/providers"
      end
    end
  end

  describe "GET /providers" do
    context "with a pending registration" do
      let!(:provider) do
        FaspClient::Provider.create(
          name: "Example FASP",
          base_url: "https://fasp.example.com",
          server_id: "b2ks6vm8p23w",
          public_key: "pDnfhQyTX06RNDhyDI7yMlSohxcpOzHF/xUbJ5DTgAA="
        )
      end

      before do
        get "/fasp/providers"
      end

      it "shows provider in list" do
        expect(response.body).to include(provider.name)
      end

      it "shows provider fingerprint" do
        expect(response.body).to include(provider.fingerprint)
      end

    end
  end
end
