
require "factory_bot"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  FactoryBot.definition_file_paths = [ FaspClient::Engine.root.join("spec/factories") ]
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
