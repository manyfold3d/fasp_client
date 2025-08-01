require "rails_helper"

# registration POST   /registration(.:format)              registrations#create

RSpec.describe "Providers", type: :request do
  describe "POST /registration" do
    let(:headers) { { "CONTENT_TYPE" => "application/json" } }
    let(:params) do
      {
        "name" => "Example FASP",
        "baseUrl" => "https://fasp.example.com",
        "serverId" => "b2ks6vm8p23w",
        "publicKey" => "FbUJDVCftINc9FlgRu2jLagCVvOa7I2Myw8aidvkong="
      }
    end
    it "succeeds" do
      post "/fasp/registration", params: params.to_json, headers: headers
      expect(response).to have_http_status :created
    end

    it "creates a new provider record"

    [
      "name",
      "baseUrl",
      "serverId",
      "publicKey"
    ].each do |key|
      it "returns bad request if missing #{key} parameter" do
        post "/fasp/registration", params: params.except(key)
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
