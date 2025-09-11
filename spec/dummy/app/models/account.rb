class Account < ApplicationRecord
  include FaspClient::DataSharing::Lifecycle

  fasp_share_lifecycle category: "account", uri_method: :uri

  def uri
    "https://example.com/accounts/#{id}"
  end
end
