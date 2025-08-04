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

      it "responds with a generated ID for the provider"

      it "responds with a local public key"

      it "responds with a completion URI" do
        expect(response.parsed_body["registrationCompletionUri"]).to eq "http://www.example.com/fasp/providers"
      end
    end
  end
end
