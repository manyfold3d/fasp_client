require "rails_helper"

# registration POST   /registration(.:format)              registrations#create

RSpec.describe "Providers", type: :request do
  describe "POST /registration" do
    let(:params) { {} }
    it "succeeds" do
      post "/fasp/registration", params: params
      expect(response).to have_http_status :created
    end

    it "creates a new provider record"

    [].each do |key|
      it "returns bad request if missing #{key} parameter" do
        post "/fasp/registration", params: params.except(key)
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
