# FaspClient
A Rails engine that implements the non-provider side of the [Fediverse Auxiliary Service Provider (FASP)](https://fediscovery.org) standard.

IMPORTANT NOTE: This code is in its very early days. The database migration will be changing up until the first release is tagged. DON'T use it in production yet, as you WILL need to rollback and re-migrate until it stabilises.

## Features

* [Base URL discovery](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#base-url) ✅
* [Request integrity](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#request-integrity) ⏳
* [Authentication](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#authentication) ⏳
* [Provider registration](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md) ✅
* [Accepting registration requests](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md) ✅
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
bin/rails fasp_client:install:migrations && bin/rails db:migrate
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

If you're using [Federails](https://gitlab.com/experimentslabs/federails), you can add this to the metadata using the configuration option (currently only on the `nodeinfo-metadata` branch):

```ruby
conf.nodeinfo_metadata = -> do
	{"faspBaseUrl" => Rails.application.routes.url_helpers.fasp_client_url}
end
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

This code was originally written for the [Manyfold](https://github.com/manyfold3d/manyfold) project, which is funded through [NGI0 Entrust](https://nlnet.nl/entrust), a fund established by [NLnet](https://nlnet.nl) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu) program. Learn more at the [NLnet project page](https://nlnet.nl/project/Personal-3D-archive).

[<img src="https://nlnet.nl/logo/banner.png" alt="NLnet foundation logo" width="20%" />](https://nlnet.nl)
[<img src="https://nlnet.nl/image/logos/NGI0_tag.svg" alt="NGI Zero Logo" width="20%" />](https://nlnet.nl/entrust)
