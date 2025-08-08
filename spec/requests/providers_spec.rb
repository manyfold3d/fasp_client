require "rspec-uuid"

# registration POST   /registration(.:format)              registrations#create

RSpec.describe "Providers", type: :request do
  describe "POST /registration" do
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:params) { attributes_for(:provider).transform_keys { |it| it.to_s.camelize(:lower) } }
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
        expect(response.parsed_body["registrationCompletionUri"]).to eq "http://www.example.com/fasp/providers/1/edit"
      end
    end
  end

  describe "GET /providers" do
    let!(:provider) { create :provider }

    context "without an authenticated user" do
      it "denies access" do
        get "/fasp/providers"
        expect(response).to have_http_status :forbidden
      end
    end

    context "with an authenticated user", :with_authenticated_user do
      it "shows provider in list" do
        get "/fasp/providers"
        expect(response.body).to include(provider.name)
      end

      it "uses application layout from main app by default" do
        get "/fasp/providers"
        expect(response.body).to include("Dummy")
      end

      it "can access route helpers from main app" do
        get "/fasp/providers"
        expect(response.body).to include("go home")
      end

      it "uses main ApplicationController as base if specified" do
        get "/fasp/providers"
        expect(response.body).to include("using main ApplicationController as base")
      end
    end
  end

  describe "GET /providers/{id}/edit" do
    let!(:provider) { create :provider }

    before do
      get "/fasp/providers/#{provider.to_param}/edit"
    end

    context "without an authenticated user" do
      it "denies access" do
        expect(response).to have_http_status :forbidden
      end
    end

    context "with an authenticated user", :with_authenticated_user do
      it "shows provider fingerprint" do
        expect(response.body).to include(provider.fingerprint)
      end
    end
  end

  describe "PATCH /providers/{id}", vcr: { cassette_name: "services/provider_info_service_spec/success" } do
    let(:provider) { create :provider, :registered }

    context "without an authenticated user" do
      it "denies access" do
        patch "/fasp/providers/#{provider.to_param}", params: { provider: { status: "approved" } }
        expect(response).to have_http_status :forbidden
      end
    end

    context "with an authenticated user", :with_authenticated_user do
      it "redirects back to provider page" do
        patch "/fasp/providers/#{provider.to_param}", params: { provider: { status: "pending" } }
        expect(response).to redirect_to("/fasp/providers/1/edit")
      end

      it "can accept provider" do
        expect {
          patch "/fasp/providers/#{provider.to_param}", params: { provider: { status: "approved" } }
        }.to change { provider.reload.status }.from("pending").to("approved")
      end

      it "can deny provider" do
        expect {
          patch "/fasp/providers/#{provider.to_param}", params: { provider: { status: "denied" } }
        }.to change { provider.reload.status }.from("pending").to("denied")
      end
    end
  end
end
