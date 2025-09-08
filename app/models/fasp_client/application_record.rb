module FaspClient
  class ApplicationRecord < ActiveRecord::Base
    CATEGORIES = [ "content", "account" ]

    self.abstract_class = true
  end
end
