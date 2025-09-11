RSpec.describe "BackfillRequests", type: :request do
  describe "POST /data_sharing/v0/backfill_requests" do
    let(:headers) {
      {
        "Content-Type" => "application/json",
        "Signature-Input" => "sig1=(\"@method\" \"@target-uri\" \"content-digest\"); created=1728467285; keyid=\"#{provider.uuid}\""
      }
    }
    let(:request) { post "/fasp/data_sharing/v0/backfill_requests", params: params, headers: headers, as: :json }
    let(:provider) { create :provider }

    before do
      allow(FaspClient::Provider).to receive(:find_by).with(uuid: provider.uuid).and_return(provider)
      allow(provider).to receive(:valid_request?).and_return(true)
    end

    context "when requesting account backfill" do
      let(:params) { { "category": "account",  "maxCount": 100 } }

      it_behaves_like "signed response"

      it "creates a backfill request" do
        expect { request }.to change(FaspClient::BackfillRequest, :count).from(0).to(1)
      end

      it "returns CREATED code" do
        request
        expect(response).to have_http_status :created
      end

      it "returns request ID" do
        request
        expect(JSON.parse(response.body)).to eq({
          "backfillRequest" => {
            "id" => FaspClient::BackfillRequest.last.id.to_s
          }
        })
      end
    end

    context "when subscribing to content lifecycle events" do
      let(:params) { { "category": "content", "maxCount": 100 } }

      it_behaves_like "signed response"

      it "creates a backfill request" do
        expect { request }.to change(FaspClient::BackfillRequest, :count).from(0).to(1)
      end

      it "returns CREATED code" do
        request
        expect(response).to have_http_status :created
      end

      it "returns request ID" do
        request
        expect(JSON.parse(response.body)).to eq({
          "backfillRequest" => {
            "id" => FaspClient::BackfillRequest.last.id.to_s
          }
        })
      end
    end

    context "with no key ID to identify provider" do
      let(:params) { { "category": "account", "maxCount": 100 } }
      let(:headers) { { "Content-Type" => "application/json" } }

      it "returns correct error code" do
        request
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with incorrect signature" do
      let(:params) { { "category": "account", "maxCount": 100 } }

      before do
        allow(provider).to receive(:valid_request?).and_return(false)
        allow(FaspClient::Provider).to receive(:find_by).with(uuid: provider.uuid).and_return(provider)
      end

      it "returns correct error code" do
        request
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
