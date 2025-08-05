# FaspClient
A Rails engine that implements the non-provider side of the [Fediverse Auxiliary Service Provider (FASP)](https://fediscovery.org) standard.

## Features

* [Base URL discovery](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#base-url) ✅
* [Request integrity](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#request-integrity) ⏳
* [Authentication](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#authentication) ⏳
* [Provider registration](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md) ✅
* [Accepting registration requests](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md) ⏳
* [Selecting capabilities](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md#selecting-capabilities) ⏳
* [Fetching FASP information](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/provider_info.md) ⏳
* [Capability APIs](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/provider_specifications.md) ⏳

## Installation

Add to your application's Gemfile:

```ruby
gem "fasp_client", github: "manyfold3d/fasp_client"
```

Install and run migrations

```shell
bin/rails fasp_client:install:migrations
bin/rails rake db:migrate
```

## Usage

Mount the engine in your `routes.rb` file:

```ruby
mount FaspClient::Engine => "/fasp"
```

Add the base URL to your nodeinfo metadata:

```ruby
"faspBaseUrl" => Rails.application.routes.url_helpers.fasp_client_url
```

If you're using Federails, you can add this to the metadata using the (soon-to-be-released) configuration option:

```ruby
conf.nodeinfo_metadata = -> do
	{"faspBaseUrl" => Rails.application.routes.url_helpers.fasp_client_url}
end
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
