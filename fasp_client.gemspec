require_relative "lib/fasp_client/version"

Gem::Specification.new do |spec|
  spec.name        = "fasp_client"
  spec.version     = FaspClient::VERSION
  spec.authors     = [ "James Smith" ]
  spec.email       = [ "james@floppy.org.uk" ]
  spec.homepage    = "https://github.com/manyfold3d/fasp_client"
  spec.summary     = "A Rails engine for FASP client apps"
  spec.description = "A Rails engine that implements the non-provider side of the Fediverse Auxiliary Service Provider (FASP) standard."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/manyfold3d/fasp_client"
  spec.metadata["changelog_uri"] = "https://github.com/manyfold3d/fasp_client/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE.md", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "~> 8.0"
  spec.add_dependency "ed25519", "~> 1.4"

  spec.add_development_dependency "rubocop-rails-omakase", "~> 1.1"
  spec.add_development_dependency "rspec-rails", "~> 8.0"
  spec.add_development_dependency "byebug", "~> 12.0"
  spec.add_development_dependency "rspec-uuid", "~> 0.6"
  spec.add_development_dependency "vcr", "~> 6.3"
  spec.add_development_dependency "webmock", "~> 3.25"
end
