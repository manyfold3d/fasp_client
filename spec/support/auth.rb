RSpec.configure do |config|
  config.around(:each, :with_authenticated_user) do |example|
    FaspClient.configure { |conf| conf.authenticate = ->(request) { true } }
    example.run
    FaspClient.configure { |conf| conf.authenticate = ->(request) { } }
  end
end
