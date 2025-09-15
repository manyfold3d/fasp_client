# FaspClient
A Rails engine that implements the non-provider side of the [Fediverse Auxiliary Service Provider (FASP)](https://fediscovery.org) standard.

## Features

* [Base URL discovery](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#base-url) ✅
* [Request integrity](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#request-integrity) ✅
* [Authentication](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/protocol_basics.md#authentication) ✅
* [Provider registration](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md) ✅
* [Accepting registration requests](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md) ✅
* [Selecting capabilities](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md#selecting-capabilities) ✅
* [Fetching FASP information](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/provider_info.md) ✅
* [Discovery APIs](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/README.md)
  * [account_search](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/account_search/v0.1/account_search.md) ✅
  * [follow_recomendation](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/follow_recommendation/v0.1/follow_recommendation.md) ✅
  * [data_sharing](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/data_sharing/v0.1/data_sharing.md) ✅ + ⏳ (no backfill yet)
  * [trends](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/trends/v0.1/trends.md) ⏳

## Installation

Add to your application's Gemfile:

```ruby
gem "fasp_client"
```

Install configuration and run migrations (you'll also want to do this when upgrading).

```shell
bin/rails generate fasp_client:install && bin/rails db:migrate
```

You will probably want to customise the view templates used for editing and listing providers.
You can copy the default views like so:

```shell
bin/rails generate fasp_client:views
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

Edit `config/initializers/fasp_client.rb` and add customise the template `authenticate` method. It should return true if the current user should be able to access the provider approval/edit pages.

Once you've done that, you can sign up to FASP providers using the URL of your site, and you should be able to register, approve, and choose capabilities.

### Capabilities

#### account_search

Get a list of accounts matching the provided search term, returned as a simple array of account URIs. Provide the optional `limit` parameter to control now many results are returned (default = 20).

```ruby
my_provider.account_search("mastodon", limit: 5)
=> ["https://mastodon.social/users/Gargron"]
```

#### data_sharing

Automatically shares data from your app to the FASP on demand. To configure one of your models to be included in data sharing, include the appropriate concern and set the configuration:

```ruby
class MyModel < ApplicationRecord
  include FaspClient::DataSharing::Lifecycle

  fasp_share_lifecycle category: "account", uri_method: :my_canonical_uri

	def my_canonical_uri
		# Any method that returns the canonical activitypub URI for this object
	end
end
```

Only lifecycle events are currently supported, trending events will be implemented in future. Valid categories are currently `account`, or `content` (see [the spec](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/data_sharing/v0.1/data_sharing.md) for details).

The actual announcements are then sent to all subscribed providers by a background ActiveJob, using the `default` queue. You can set a specific queue name by adding an optional `queue` parameter to `fasp_share_lifecycle`:

```ruby
fasp_share_lifecycle category: "account", uri_method: :my_canonical_uri, queue: "fasp_broadcasts"
```

You can also add an `only_if` argument to point to a method that returns true if an item should be shared, allowing you to only share certain items:

```ruby
fasp_share_lifecycle category: "account", uri_method: :my_canonical_uri, only_if: :public?
```

Only new lifecycle events are currently sent. Whilst backfill requests can be made, they aren't serviced yet (see https://github.com/manyfold3d/fasp_client/issues/25).

#### follow_recommendation

Get a list of follow recommendations, returned as a simple array of account URIs. The account URI argument is required by the [spec](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/follow_recommendation/v0.1/follow_recommendation.md), but won't necessarily affect the results, depending on the server implementation.

```ruby
my_provider.follow_recommendation(your_account_uri)
=> [
	"https://mastodon.me.uk/users/Floppy",
	"https://mastodon.social/users/Gargron"
]
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

This code was originally written for the [Manyfold](https://github.com/manyfold3d/manyfold) project, which is funded through [NGI0 Entrust](https://nlnet.nl/entrust), a fund established by [NLnet](https://nlnet.nl) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu) program. Learn more at the [NLnet project page](https://nlnet.nl/project/Personal-3D-archive).

[<img src="https://nlnet.nl/logo/banner.png" alt="NLnet foundation logo" width="20%" />](https://nlnet.nl)
[<img src="https://nlnet.nl/image/logos/NGI0_tag.svg" alt="NGI Zero Logo" width="20%" />](https://nlnet.nl/entrust)
