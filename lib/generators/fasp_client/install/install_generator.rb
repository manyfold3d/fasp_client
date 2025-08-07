module FaspClient
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_initializer_file
      copy_file "fasp_client.rb", Rails.root.join("config", "initializers", "fasp_client.rb")
    end

    def generate_migrations
      rake "fasp_client:install:migrations"
    end
  end
end
