class Account < ApplicationRecord
  include FaspClient::DataSharing::Lifecycle

  fasp_share_lifecycle category: "account", uri_method: :uri, only_if: :announce?

  def uri
    "https://example.com/accounts/#{id}"
  end

  def announce?
    true
  end
end
