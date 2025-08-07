require "fasp_client/version"
require "fasp_client/engine"
require "fasp_client/configuration"

module FaspClient
  def self.table_name_prefix
    "fasp_client_"
  end

  def self.configure
    yield Configuration.instance
  end
end
