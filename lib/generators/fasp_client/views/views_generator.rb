module FaspClient
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../app/views", __dir__)

    def copy_views
      directory "fasp_client", Rails.root.join("app", "views", "fasp_client")
    end
  end
end
