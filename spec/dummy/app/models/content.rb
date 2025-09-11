class Content < ApplicationRecord
  include FaspClient::DataSharing::Lifecycle

  fasp_share_lifecycle category: "content", uri_method: :uri

  def uri
    "https://example.com/contents/#{id}"
  end
end
