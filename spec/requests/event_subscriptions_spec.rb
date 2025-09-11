RSpec.describe "EventSubscriptions", type: :request do
  describe "POST /data_sharing/v0/event_subscriptions" do
    let(:headers) {
      {
        "Content-Type" => "application/json",
        "Signature-Input" => "sig1=(\"@method\" \"@target-uri\" \"content-digest\"); created=1728467285; keyid=\"#{provider.uuid}\""
      }
    }
    let(:request) { post "/fasp/data_sharing/v0/event_subscriptions", params: params, headers: headers, as: :json }
    let(:provider) { create :provider }

    before do
      allow(FaspClient::Provider).to receive(:find_by).with(uuid: provider.uuid).and_return(provider)
      allow(provider).to receive(:valid_request?).and_return(true)
    end

    context "when subscribing to account lifecycle events" do
      let(:params) { { "category": "account", "subscriptionType": "lifecycle" } }

      it_behaves_like "signed response"

      it "creates a subscription" do
        expect { request }.to change(FaspClient::EventSubscription, :count).from(0).to(1)
      end

      it "returns CREATED code" do
        request
        expect(response).to have_http_status :created
      end

      it "returns subscription ID" do
        request
        expect(JSON.parse(response.body)).to eq({
          "subscription" => {
            "id" => FaspClient::EventSubscription.last.id.to_s
          }
        })
      end
    end

    context "when subscribing to account trends" do
      let(:params) { { "category": "account", "subscriptionType": "trends" } }

      it_behaves_like "signed response"

      it "doesn't create a subscription" do
        expect { request }.not_to change(FaspClient::EventSubscription, :count)
      end

      it "returns unprocessable content code" do
        request
        expect(response).to have_http_status :unprocessable_content
      end
    end

    context "when subscribing to content lifecycle events" do
      let(:params) { { "category": "content", "subscriptionType": "lifecycle" } }

      it_behaves_like "signed response"

      it "creates a subscription" do
        expect { request }.to change(FaspClient::EventSubscription, :count).from(0).to(1)
      end

      it "returns CREATED code" do
        request
        expect(response).to have_http_status :created
      end

      it "returns subscription ID" do
        request
        expect(JSON.parse(response.body)).to eq({
          "subscription" => {
            "id" => FaspClient::EventSubscription.last.id.to_s
          }
        })
      end
    end

    context "when subscribing to content trends" do
      let(:params) { { "category": "content", "subscriptionType": "trends" } }

      it_behaves_like "signed response"

      it "doesn't create a subscription" do
        expect { request }.not_to change(FaspClient::EventSubscription, :count)
      end

      it "returns unprocessable content code" do
        request
        expect(response).to have_http_status :not_implemented
      end
    end


    context "with no key ID to identify provider" do
      let(:params) { { "category": "account", "subscriptionType": "lifecycle" } }
      let(:headers) { { "Content-Type" => "application/json" } }

      it "returns correct error code" do
        request
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with incorrect signature" do
      let(:params) { { "category": "account", "subscriptionType": "lifecycle" } }

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
  describe "DELETE /data_sharing/v0/event_subscriptions/{id}" do
    let(:headers) {
      {
        "Content-Type" => "application/json",
        "Signature-Input" => "sig1=(\"@method\" \"@target-uri\" \"content-digest\"); created=1728467285; keyid=\"#{provider.uuid}\""
      }
    }
    let(:request) { delete "/fasp/data_sharing/v0/event_subscriptions/#{subscription_id}", headers: headers }
    let(:provider) { create :provider }

    before do
      allow(FaspClient::Provider).to receive(:find_by).with(uuid: provider.uuid).and_return(provider)
      allow(provider).to receive(:valid_request?).and_return(true)
    end

    context "with a matching subscription" do
      let!(:subscription_id) { create(:event_subscription, :account_lifecycle, fasp_client_provider: provider).id }

      it_behaves_like "signed response"

      it "removes subscription" do
        expect { request }.to change(FaspClient::EventSubscription, :count).from(1).to(0)
      end

      it "returns NO CONTENT for success" do
        request
        expect(response).to have_http_status :no_content
      end
    end
    context "with an incorrect subscription ID" do
      let(:subscription_id) { 999 }

      it "doesn't remove subscription" do
        expect { request }.not_to change(FaspClient::EventSubscription, :count)
      end

      it "returns NOT FOUND" do
        request
        expect(response).to have_http_status :not_found
      end
    end

    context "when removing a subscription from a different provider" do
      let!(:subscription_id) { create(:event_subscription, :account_lifecycle, fasp_client_provider: create(:provider)).id }

      it "doesn't remove subscription" do
        expect { request }.not_to change(FaspClient::EventSubscription, :count)
      end

      it "returns NOT FOUND" do
        request
        expect(response).to have_http_status :not_found
      end
    end

    context "with no key ID to identify provider" do
      let(:subscription_id) { 1 }
      let(:headers) { { "Content-Type" => "application/json" } }

      it "returns correct error code" do
        request
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with incorrect signature" do
      let(:subscription_id) { 1 }

      before do
        allow(FaspClient::Provider).to receive(:find_by).with(uuid: provider.uuid).and_return(provider)
        allow(provider).to receive(:valid_request?).and_return(false)
      end

      it "returns correct error code" do
        request
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
